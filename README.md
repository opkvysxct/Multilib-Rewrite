<div align="center">
  <h1>
    Multilib Rewrite
  </h1>
</div>

A Roblox library that allows you to perform *simple* task even *simplier*. See ->
[**Docs**](https://github.com/2115oskar2115/Multilib-Rewrite/wiki/Multilib-Wiki) for installation and usage help!

## Why Multilib exists?
I just found out that i use the same things over and over across all my projects, and thats got pretty messy, so i decied to write a library that can handle all of those things for me, first version was pretty simple, to be honest it was to simple, so i decided to rewrite the whole library to add support for multiple modules, classes etc. And thats why Multilib exists.

## How do i use it?
You can find everything in the [wiki](https://github.com/2115oskar2115/Multilib-Rewrite/wiki/Multilib-Wiki).
But if you want just the loading schemat, then here you go!
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
