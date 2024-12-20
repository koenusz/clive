import { Address } from '@emurgo/cardano-serialization-lib-browser';



export function test() {
    const addr = Address.from_bech32("addr1vyt3w9chzut3w9chzut3w9chzut3w9chzut3w9chzut3w9cj43ltf")
    console.log(addr)
}