import hashlib
import time

from cryptography.hazmat.primitives.asymmetric import rsa, padding
from cryptography.hazmat.primitives import hashes, serialization
from cryptography.exceptions import InvalidSignature

def generate_rsa_keypair():
    private_key = rsa.generate_private_key(
        public_exponent=65537,
        key_size=2048
    )
    public_key = private_key.public_key()
    return private_key, public_key

def save_keys_to_file(private_key, public_key, priv_path="private_key.pem", pub_path="public_key.pem"):
    # 保存私钥
    private_pem = private_key.private_bytes(
        encoding=serialization.Encoding.PEM,
        format=serialization.PrivateFormat.PKCS8,
        encryption_algorithm=serialization.NoEncryption()
    )
    with open(priv_path, "wb") as f:
        f.write(private_pem)

    # 保存公钥
    public_pem = public_key.public_bytes(
        encoding=serialization.Encoding.PEM,
        format=serialization.PublicFormat.SubjectPublicKeyInfo
    )
    with open(pub_path, "wb") as f:
        f.write(public_pem)

def sign_with_private_key(private_key, message: bytes):
    signature = private_key.sign(
        message,
        padding.PKCS1v15(),
        hashes.SHA256()
    )
    return signature

def verify_with_public_key(public_key, message: bytes, signature: bytes):
    try:
        public_key.verify(
            signature,
            message,
            padding.PKCS1v15(),
            hashes.SHA256()
        )
        return True
    except InvalidSignature:
        return False

def pow_challenge(prefix_zeros, private_key=None, public_key=None):
    nickname = "luckyme"
    nonce = 0
    prefix = "0" * prefix_zeros
    start_time = time.time()
    while True:
        content = f"{nickname}{nonce}"
        hash_val = hashlib.sha256(content.encode()).hexdigest()
        if hash_val.startswith(prefix):
            elapsed = time.time() - start_time
            print(f"满足 {prefix_zeros} 个 0：")
            print(f"用时: {elapsed:.4f} 秒")
            print(f"内容: {content}")
            print(f"Hash: {hash_val}\n")
            # 只对4~6个0的情况做签名和验证
            if prefix_zeros < 7 and private_key and public_key:
                message = content.encode()
                signature = sign_with_private_key(private_key, message)
                print(f"签名: {signature.hex()}")
                is_valid = verify_with_public_key(public_key, message, signature)
                print(f"公钥验证结果: {is_valid}\n")
            break
        nonce += 1

if __name__ == "__main__":
    # 生成RSA密钥对
    private_key, public_key = generate_rsa_keypair()
    # 保存密钥到文件
    save_keys_to_file(private_key, public_key)
    pow_challenge(4, private_key, public_key)
    pow_challenge(5, private_key, public_key)
    pow_challenge(6, private_key, public_key)