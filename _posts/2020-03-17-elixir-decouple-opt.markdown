---
layout: default
banner: main
title:  "Decouple OTP Applications"
---

# Intro

Elixir OTP is a layer of abstraction on top of the elixir concurency primitives (processes, message passing). This includes things like GenServers, Supervisors, and Registries. Using these abstractions you can quickly build a fault-tolerant, distributed system. 

## How processes communicate with eachother

### PID

In elixir every process has a pid, you can use this to send data from one process to another. These packets of data are called messages. You cannot assign a process a pid, they are assigned by the BEAM at runtime. If a process wants to send a message to a recieving process, it needs to be started after the recieving process and be given the recieving processes pid.

### Named GenServers

In the opts of a GenServer's start_link you have the option of giving a [name: genserver_name]

# The Problem

How do you design a decoupled system when your processes are tied to a name. Two instances of a named genserver cannot run at the same time because they will have name conflicts.

# The Solution

At startup time you have the oprotunity of giving the genserver a name. Pass in keyword lists through start_link as opts. If a name is given in the opts, use that, otherwise use Keyword.get\3 to provide a default. 

In your tests you can specify a unique name, while still having your actual process running.

