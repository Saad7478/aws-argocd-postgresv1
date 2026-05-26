Host kube
    HostName ${kube_ip}
    User rocky
    IdentityFile ~/.ssh/kube-lab-config
    ForwardAgent yes
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null