[all]
legipro:22     ansible_host=192.168.0.101
envypro:22     ansible_host=192.168.0.102
minipro:22     ansible_host=192.168.0.103

[all:vars]
mfsmain         = envypro
mfsmount        = true 
mfschunk        = true
