#!/usr/bin/python3
import os

file_path = os.path.join(os.path.dirname(__file__), "mattermost")
old_key = (
    "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAyZmShlU8Z8HdG0IWSZ8r\n"
    "tSyzyxrXkJjsFUf0Ke7bm/TLtIggRdqOcUF3XEWqQk5RGD5vuq7Rlg1zZqMEBk8N\n"
    "EZeRhkxyaZW8pLjxwuBUOnXfJew31+gsTNdKZzRjrvPumKr3EtkleuoxNdoatu4E\n"
    "HrKmR/4Yi71EqAvkhk7ZjQFuF0osSWJMEEGGCSUYQnTEqUzcZSh1BhVpkIkeu8Kk\n"
    "1wCtptODixvEujgqVe+SrE3UlZjBmPjC/CL+3cYmufpSNgcEJm2mwsdaXp2OPpfn\n"
    "na0v85XL6i9ote2P+fLZ3wX9EoioHzgdgB7arOxY50QRJO7OyCqpKFKv6lRWTXuSt\n"
    "hwIDAQAB"
)
new_key = (
    "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAmCvX08GJRrbqYZbJtGXj\n"
    "XYmoRva8Yvk43uspBiNQoFYp0N8mWfmDhCqUzW7i9GZKDlEgn2IYoL2GxiRpSJaP\n"
    "irK8FGwD+o0efzhTHeGWOvD4e0c8gQZbpe85p17vha2i2xZiWQ4UBlq7jUFcuy6F\n"
    "fcgUK+fVI8+IvvjtkIZRqRLLlXCRnpuEWq/8vJF7yHql2jxiGUdXkFkZsgPgXizv\n"
    "mY0op5ui6n/f7ljVIIdad10OLNsW/xxk6VxirAIyuDZK9GSRGjjvDhi/yNcC0yJe\n"
    "jYTCeDoD+GVh3twk+RyFo9S1AG7kKWtHTNu3MLh9/XnRJdpgrlAE7Z4+VfHrsbXp\n"
    "twIDAQAB"
)

try:
    with open(file_path, "r+b") as fp:
        content = fp.read().decode('utf-8')
        pos = content.find(old_key)
        
        if pos != -1:
            fp.seek(pos)
            fp.write(new_key.encode('utf-8'))
            print("OK")
        else:
            print("Nothing to do (key not found)")
except FileNotFoundError:
    print(f"Error: File '{file_path}' not found")
except Exception as e:
    print(f"An error occurred: {str(e)}")
