const express = require('express');
const { createProxyMiddleware } = require('http-proxy-middleware');
const cors = require('cors');

const app = express();
const PORT = 8546; // 代理端口
const ANVIL_URL = 'http://localhost:8545'; // Anvil RPC URL

// 启用 CORS
app.use(cors());
app.use(express.json());

// Otterscan 需要的方法的模拟响应
const mockResponses = {
  // API 级别 - 让 Otterscan 认为这是兼容的节点
  'ots_getApiLevel': () => 8,
  
  // 获取交易错误信息 - 返回空表示没有错误
  'ots_getTransactionError': () => null,
  
  // 获取合约创建者信息
  'ots_getContractCreator': () => null,
  
  // 获取交易收据 - 如果原始方法失败，返回基本信息
  'ots_getTransactionReceipt': (params) => null,
  
  // 跟踪交易
  'ots_traceTransaction': () => [],
  
  // 获取区块详细信息
  'ots_getBlockDetails': () => null,
  
  // 获取内部操作
  'ots_getInternalOperations': () => [],
  
  // 搜索交易
  'ots_searchTransactionsAfter': () => ({
    txs: [],
    receipts: [],
    firstPage: true,
    lastPage: true
  }),
  
  'ots_searchTransactionsBefore': () => ({
    txs: [],
    receipts: [],
    firstPage: true,
    lastPage: true
  })
};

// JSON-RPC 请求处理中间件
app.post('/', (req, res, next) => {
  console.log(`🔄 Received: ${req.method} ${req.url}`);
  
  if (req.body && req.body.method) {
    const method = req.body.method;
    console.log(`📡 RPC Method: ${method}`);
    
    // 检查是否为需要模拟的 Otterscan 方法
    if (mockResponses[method]) {
      console.log(`🎭 Mocking method: ${method}`);
      
      // 创建模拟响应
      const mockResult = mockResponses[method](req.body.params || []);
      const response = {
        jsonrpc: "2.0",
        id: req.body.id,
        result: mockResult
      };
      
      return res.json(response);
    }
  }
  
  // 如果不是模拟方法，继续到代理
  next();
});

// 主要代理中间件
app.use('/', createProxyMiddleware({
  target: ANVIL_URL,
  changeOrigin: true,
  onProxyReq: (proxyReq, req, res) => {
    console.log(`🔄 Proxying to Anvil: ${req.method} ${req.url}`);
  },
  onProxyRes: (proxyRes, req, res) => {
    // 记录响应
    console.log(`✅ Response: ${proxyRes.statusCode} for ${req.url}`);
  },
  onError: (err, req, res) => {
    console.error(`❌ Proxy Error: ${err.message}`);
    
    // 如果是 JSON-RPC 请求且为 Otterscan 方法，返回模拟响应
    if (req.body && req.body.method && mockResponses[req.body.method]) {
      const mockResult = mockResponses[req.body.method](req.body.params || []);
      const response = {
        jsonrpc: "2.0",
        id: req.body.id,
        result: mockResult
      };
      res.json(response);
    } else {
      res.status(500).json({
        jsonrpc: "2.0",
        id: req.body?.id || null,
        error: {
          code: -32603,
          message: "Internal error",
          data: err.message
        }
      });
    }
  }
}));

app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 Anvil-Otterscan Proxy Server running on http://localhost:${PORT}`);
  console.log(`📡 Forwarding requests to Anvil at ${ANVIL_URL}`);
  console.log(`🎭 Providing mock responses for Otterscan-specific methods`);
  console.log(`\n🔧 Configuration for Otterscan:`);
  console.log(`   ERIGON_URL=http://localhost:${PORT}`);
  console.log(`\n📋 Supported mock methods:`);
  Object.keys(mockResponses).forEach(method => {
    console.log(`   - ${method}`);
  });
});

// 优雅关闭
process.on('SIGTERM', () => {
  console.log('\n👋 Shutting down proxy server...');
  process.exit(0);
});

process.on('SIGINT', () => {
  console.log('\n👋 Shutting down proxy server...');
  process.exit(0);
});