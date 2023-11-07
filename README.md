<div align="center">
  <h1>
    Multilib Rewrite
  </h1>
</div>

A Roblox library that allows you to perform *simple* task even *simplier*. See ->
[**Docs**](https://github.com/2115oskar2115/Multilib-Rewrite/wiki/Multilib-Wiki) for installation and usage help!

## Why Multilib exists?
I just found out that I use the same elements repeatedly across all my projects, and it became quite messy. So, I decided to develop a library that can manage these elements for me. The initial version was quite basic, to be honest, too basic. As a result, I made the decision to rewrite the entire library to include support for multiple modules and classes, among other things. This is why Multilib came into existence.

## Installation
First you have to create a node_modules folder, then :
```bash
npm install @vysx/multilib
```

## How do i use it?
You can find everything in the [wiki](https://github.com/2115oskar2115/Multilib-Rewrite/wiki/Multilib-Wiki).
But if You want just the loading schemat, then here you go!
Server
```lua
_G.M_Loader = require(game:GetService("ReplicatedStorage").Multilib)
_G.M_Loader:InitServer(true/false) -- Logs
```
Client
```lua
_G.M_Loader = require(game:GetService("ReplicatedStorage").Multilib)
_G.M_Loader:InitClient(true/false) -- Logs
```

## Can i fork it?
You're welcome!

## Last note
Special thanks to Fengee & Sani for help.
