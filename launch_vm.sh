VM='controller'
MEMORY=2048
VRAM=64
TYPE='Linux_64'


vboxmanage createvm -name $VM -register

#vboxmanage modifyvm $VM --memory $MEMORY --vram $VRAM --acpi on --boot1 dvd --nic1 nat --nic2 bridged --bridgeadapter1 eth0

vboxmanage modifyvm $VM --memory $MEMORY --vram $VRAM --acpi on --boot1 dvd --nic1 nat 
#vboxmanage modifyvm $vm --nic2 bridged --bridgeadapter1 eth0

vboxmanage modifyvm $VM --ostype $TYPE

vboxmanage createvdi --filename $VM.vdi --size 40960

vboxManage storagectl $VM --name "IDE Controller" --add ide

vboxManage storageattach $VM --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium iso/autoinstall_ubuntu_base.iso

VboxManage storagectl $VM --name "SATA Controller" --add sata --controller IntelAHCI
VboxManage storageattach $VM --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium $VM.vdi


#vboxmanage storagectl $VM --name "IDE Controller" --add ide
#vboxmanage modifyvm $VM --boot1 dvd --hda $VM.vdi --sata on 

# port forwarding
vboxManage modifyvm $VM --natpf1 "guestssh,tcp,,2222,,22"

#vboxmanage startvm $VM
