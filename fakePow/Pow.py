import hashlib
import time

def pow_challenge(prefix_zeros):
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
            break
        nonce += 1

if __name__ == "__main__":
    pow_challenge(4)
    pow_challenge(5)

