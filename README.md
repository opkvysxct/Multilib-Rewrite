<div align="center">
  <h1>
    Multilib Rewrite
  </h1>
</div>

A Roblox library that allows you to perform *simple* task even *simplier*. See ->
[**Docs**](https://github.com/opkvysxct/Multilib-Rewrite/wiki/Multilib-Wiki) for installation and usage help!

## Why Multilib exists?
I just found out that I use the same elements repeatedly across all my projects, and it became quite messy. So, I decided to develop a library that can manage these elements for me. The initial version was quite basic, to be honest, too basic. As a result, I made the decision to rewrite the entire library to include support for multiple modules and classes, among other things. This is why Multilib came into existence.

## Installation
### Lets make it clear, its meant to be used with [rojo](https://rojo.space/)!
First step :
```bash
npm init
```
Second step :
```bash
npm install @vysx/multilib
```
Third step :
add a path to your default.project.json in rojo
```json
"ReplicatedStorage": {
	"Multilib" : {
		"$path": "node_modules/@vysx/multilib"
	},
}
```

## How do i use it?
You can find everything in the [wiki](https://github.com/opkvysxct/Multilib-Rewrite/wiki/Multilib-Wiki).
But if You want just the loading schemat, then here you go!
Server
```lua
_G.MLoader = require(game:GetService("ReplicatedStorage").Multilib)
_G.MLoader:InitServer(true/false) -- Logs
```
Client
```lua
_G.MLoader = require(game:GetService("ReplicatedStorage").Multilib)
_G.MLoader:InitClient(true/false) -- Logs
```

## Can i fork it?
You're welcome!

## Last note
Special thanks to [Fengee](https://github.com/NiceAssasin123) & [Sani](https://github.com/AlwaysSunnySani) for help.
