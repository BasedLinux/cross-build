{
  inputs.nixos-generators = {
    url = "github:nix-community/nixos-generators";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, nixos-generators, ... }:
    let
      formats = ["amazon" "azure" "cloudstack" "do" "docker" "gce" "hyperv" "install-iso" "install-iso-hyperv" "iso" "kexec" "kexec-bundle" "kubevirt" "linode" "lxc" "lxc-metadata" "openstack" "proxmox" "proxmox-lxc" "qcow" "qcow-efi" "raw" "raw-efi" "sd-aarch64" "sd-aarch64-installer" "sd-x86_64" "vagrant-virtualbox" "virtualbox" "vm" "vm-bootloader" "vm-nogui" "vmware"];
      systems = ["x86_64-linux" "aarch64-linux"];
      mkFormat = format: system: nixos-generators.nixosGenerate {
        inherit system format;
        modules = [];
      };
      mkFormats = builtins.listToAttrs (builtins.concatMap (format:
        map (system: {
          name = "${format}-${system}";
          value = mkFormat format system;
        }) systems
      ) formats);
    in mkFormats;
}
