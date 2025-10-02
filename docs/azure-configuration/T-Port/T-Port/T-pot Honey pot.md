

T-pot Honey pot


Copy SSH KEYs 

ssh-copy-id -i ~/.ssh/id_rsa.pub soc-admin@<VM_PUBLIC_IP> -p 64295

OR
copy from local machine
cat ~/.ssh/id_rsa.pub

Then paste in VM
mkdir -p ~/.ssh
nano ~/.ssh/authorized_keys

correect permission 
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
<YOUR_PUBLIC_SSH_KEY_HERE>
                                                                                                                                     

### Please review for possible honeypot port conflicts.
### While SSH is taken care of, other services such as
### SMTP, HTTP, etc. might prevent T-Pot from starting.

Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       User       Inode      PID/Program name    
tcp        0      0 0.0.0.0:64295           0.0.0.0:*               LISTEN      0          38740      6853/sshd: /usr/sbi 
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      0          8441       1452/sshd: /usr/sbi 
tcp        0      0 127.0.0.54:53           0.0.0.0:*               LISTEN      991        5941       489/systemd-resolve 
tcp        0      0 127.0.0.53:53           0.0.0.0:*               LISTEN      991        5939       489/systemd-resolve 
tcp6       0      0 :::64295                :::*                    LISTEN      0          38742      6853/sshd: /usr/sbi 
tcp6       0      0 :::22                   :::*                    LISTEN      0          8443       1452/sshd: /usr/sbi 
udp        0      0 127.0.0.54:53           0.0.0.0:*                           991        5940       489/systemd-resolve 
udp        0      0 127.0.0.53:53           0.0.0.0:*                           991        5938       489/systemd-resolve 
udp        0      0 10.0.0.4:68             0.0.0.0:*                           998        7630       676/systemd-network 
udp        0      0 127.0.0.1:323           0.0.0.0:*                           0          9336       953/chronyd         
udp6       0      0 ::1:323                 :::*                                0          9337       953/chronyd         

### Done. Please reboot and re-connect via SSH on tcp/64295.
### Make sure to deploy SSH keys to this SENSOR and disable SSH password authentication.
### On HIVE run the tpotce/deploy.sh script to join this SENSOR to the HIVE.

soc-admin@AllyshipCorp-Net-WestEU:~$ 



