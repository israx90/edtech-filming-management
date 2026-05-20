import os
import ftplib
import time
import re

def upload_directory(ftp, local_dir, remote_dir):
    try:
        ftp.cwd(remote_dir)
    except ftplib.error_perm:
        print(f"Creating directory {remote_dir}")
        ftp.mkd(remote_dir)
        ftp.cwd(remote_dir)

    for item in os.listdir(local_dir):
        local_path = os.path.join(local_dir, item)
        if os.path.isfile(local_path):
            print(f"Uploading {item} to {remote_dir}...")
            with open(local_path, 'rb') as f:
                ftp.storbinary(f'STOR {item}', f)
        elif os.path.isdir(local_path):
            upload_directory(ftp, local_path, item)
            ftp.cwd('..')

def cache_bust_index():
    index_path = os.path.join("dist", "index.html")
    if os.path.exists(index_path):
        with open(index_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        timestamp = int(time.time())
        # Remove existing ?v=...
        content = re.sub(r'\.css\?v=\d+', '.css', content)
        content = re.sub(r'\.js\?v=\d+', '.js', content)
        
        # Add new ?v=...
        content = content.replace('.css"', f'.css?v={timestamp}"')
        content = content.replace('.js"', f'.js?v={timestamp}"')
        
        with open(index_path, 'w', encoding='utf-8') as f:
            f.write(content)
        print("✅ Cache busting applied to dist/index.html")

def main():
    host = "ftpupload.net"
    user = "if0_41857535"
    password = "Jm3cN2fzLc"
    local_dist = "dist"

    cache_bust_index()

    print(f"Connecting to {host}...")
    ftp = ftplib.FTP(host)
    ftp.login(user, password)
    ftp.set_pasv(True)

    print("Entering htdocs...")
    ftp.cwd("htdocs")

    print("Starting upload from dist/...")
    upload_directory(ftp, local_dist, ".")
    
    ftp.quit()
    print("\n✅ Upload completed successfully!")

if __name__ == "__main__":
    main()
