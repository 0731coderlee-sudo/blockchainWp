const express = require('express');
const { createProxyMiddleware } = require('http-proxy-middleware');
const cors = require('cors');

const app = express();
const PORT = 8546;
const ANVIL_URL = 'http://localhost:8545';

// 启用 CORS 和 JSON 解析
app.use(cors());
app.use(express.json({ limit: '50mb' }));

console.log('🚀 Starting Anvil-Otterscan Proxy...');

// Otterscan 需要的方法的模拟响应
const mockResponses = {
  'ots_getApiLevel': () => 8,
  'ots_getTransactionError': () => null,
  'ots_getContractCreator': () => null,
  'ots_traceTransaction': () => [],
  'ots_getBlockDetails': () => null,
  'ots_getInternalOperations': () => [],
  'ots_searchTransactionsAfter': () => ({ txs: [], receipts: [], firstPage: true, lastPage: true }),
  'ots_searchTransactionsBefore': () => ({ txs: [], receipts: [], firstPage: true, lastPage: true })
};

// 处理 JSON-RPC 请求
app.post('/', async (req, res) => {
  console.log(`📨 Received RPC: ${req.body?.method}`);
  
  // 检查是否为需要模拟的 Otterscan 方法
  if (req.body && req.body.method && mockResponses[req.body.method]) {
    console.log(`🎭 Mocking: ${req.body.method}`);
    
    const mockResult = mockResponses[req.body.method](req.body.params || []);
    const response = {
      jsonrpc: "2.0",
      id: req.body.id,
      result: mockResult
    };
    
    return res.json(response);
  }
  
  // 转发到 Anvil
  console.log(`➡️ Forwarding to Anvil: ${req.body?.method}`);
  
  try {
    const anvilResponse = await fetch(ANVIL_URL, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(req.body)
    });
    
    const result = await anvilResponse.json();
    console.log(`✅ Anvil response: ${anvilResponse.status}`);
    res.json(result);
    
  } catch (error) {
    console.error(`❌ Error forwarding to Anvil:`, error.message);
    res.status(500).json({
      jsonrpc: "2.0",
      id: req.body?.id || null,
      error: {
        code: -32603,
        message: "Internal error",
        data: error.message
      }
    });
  }
});

// 处理其他请求
app.use('/', (req, res) => {
  res.status(400).send('Bad Request - JSON-RPC only');
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 Proxy Server running on http://localhost:${PORT}`);
  console.log(`📡 Forwarding to Anvil at ${ANVIL_URL}`);
  console.log(`\n🔧 Otterscan Configuration:`);
  console.log(`   ERIGON_URL=http://localhost:${PORT}`);
  console.log(`\n📋 Mock methods:`, Object.keys(mockResponses).join(', '));
});

process.on('SIGINT', () => {
  console.log('\n👋 Shutting down...');
  process.exit(0);
});