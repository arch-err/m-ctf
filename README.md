![logo](assets/logo.png)

# Manage-CTFs

A tool to manage CTFs on-the-go, to structure your work and document your solutions quickly while playing a CTF.


# Installation

## One-line-install
*There will be a one-line-install available in the future, byt for now you'll have to install the scripts dependencies manually.*


## Manually

### Dependencies
#### Arch-based systems (AUR)
```bash
yay -S gomplate-bin yq fzf git github-cli
or
paru -S gomplate-bin yq fzf git github-cli
```

#### Nix-systems (nix-env)
```bash
nix-env -iA gomplate yq fzf git gh
```

#### Debian-based systems (apt)
```bash
apt install yq fzf git gh
```
**NOTICE:** gomplate is not a very well-known tool and may therefore be a bit more difficult to install. Consult gomplates [install guide](https://docs.gomplate.ca/installing/) for more details.


### Download the script
You can clone this repo or download the script however you want (example commands below) and add the script to your path in any way you want.
#### Examples
```bash
$ git clone https://github.com/arch-err/m-ctf.git
or
$ curl -LO https://raw.githubusercontent.com/arch-err/m-ctf/refs/heads/main/code/mctf.sh?token=GHSAT0AAAAAACXAJZVOFKHAOHGVKRJDHHDSZYYBF7Q
```
#### Oneliner
```bash
$ curl -L https://raw.githubusercontent.com/arch-err/m-ctf/refs/heads/main/code/mctf.sh?token=GHSAT0AAAAAACXAJZVOFKHAOHGVKRJDHHDSZYYBF7Q -o /opt/mctf
```


# Usage

## 1. Initialization
```bash
$ mctf init
```
This command will initialize a git repo with metadata, READMEs, challenge-templates, and more.

This action is fully interactive and needs no more flags/switches or other types of given data before execution.


## 2. Solve
```bash
$ mctf solve <challenge> (optional)
```
This command gives you a menu to select a challenge, mark it as finished in the README, and then increment the counter that keeps track of solved challenges.


## 3. Status
To show the status of the current CTF you can run the following command:
```bash
$ mctf status
```
