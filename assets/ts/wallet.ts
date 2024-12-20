

import { Cip30WalletApiWithPossibleExtensions, WindowMaybeWithCardano } from '@cardano-sdk/dapp-connector';
import { bech32 } from 'bech32';
import { Buffer } from 'buffer';
import { decode as decodeCbor } from 'cborg';
import * as SerializationLib from '@emurgo/cardano-serialization-lib-browser'

export function getWallet(name: string): Promise<Cip30WalletApiWithPossibleExtensions> {
    const cardano = (window as WindowMaybeWithCardano).cardano;
    if (cardano === undefined || cardano === null) {
        return Promise.reject("No cardano wallet installed");
    }
    if (cardano[name] === undefined) {
        return Promise.reject(`Cardano wallet ${name} is undefined`);
    }
    if (cardano[name] === null) {
        return Promise.reject(`Cardano wallet ${name} is null`);
    }
    return cardano[name].enable()
}

export async function getBalanceByName(name: string): Promise<number> {
    const wallet = await getWallet(name)
    return getBalance(wallet)
}

export async function getBalance(wallet: Cip30WalletApiWithPossibleExtensions): Promise<number> {
    const balance = await wallet.getBalance()
    return decodeCbor(Buffer.from(balance, "hex"), { useMaps: true });
}

export async function getTransactionUnpentOutputs(wallet: Cip30WalletApiWithPossibleExtensions): Promise<SerializationLib.TransactionUnspentOutputs> {
    const utxosHex = await wallet.getUtxos();

    const outputs = SerializationLib.TransactionUnspentOutputs.new();
    if (utxosHex == null) {
        return outputs
    }
    const utxos = utxosHex.map((utxoHex: string) => {
        return SerializationLib.TransactionUnspentOutput.from_bytes(Buffer.from(utxoHex, 'hex'));
    });
    utxos.forEach((utxo) => {
        const input = utxo.input();
        const amount = utxo.output().amount();
        const lovelace = amount.coin().to_str(); // Gets the amount in lovelace
        console.log(`UTXO Transaction ID: ${Buffer.from(input.transaction_id().to_bytes()).toString('hex')}`);
        console.log(`Index: ${input.index()}`);
        console.log(`Lovelace: ${lovelace}`);
        outputs.add(utxo)
    });

    return outputs
}

export function getInstalledWalletExtensions(
    supportedWallets?: Array<string>
): Array<{ name: string, icon: any }> {
    const cardano = (window as any).cardano;
    if (typeof cardano === 'undefined') {
        return [];
    }
    if (supportedWallets) {
        return Object.keys(cardano)
            .map((installedWalletName) => installedWalletName.toLowerCase())
            .filter((name) =>
                supportedWallets
                    .map((supported) => supported.toLowerCase())
                    .includes(name)

            ).map((walletName) => ({ name: walletName, icon: cardano[walletName].icon }))
            ;
    } else {
        return Object.keys(cardano)
            .filter(
                (walletExtension) =>
                    typeof cardano[walletExtension].enable === 'function'
            )
            .map((walletExtension) => walletExtension.toLowerCase())
            .map((name) => ({ name, icon: cardano[name].icon }));
    }
}

export enum NetworkId {
    MAINNET = 1,
    TESTNET = 0,
}

export function bech32FromHex(hexAddress: string) {
    hexAddress = hexAddress.toLowerCase();
    const addressType = hexAddress.charAt(0);
    const networkId = Number(hexAddress.charAt(1)) as NetworkId;
    const addressBytes = Buffer.from(hexAddress, 'hex');
    const words = bech32.toWords(addressBytes);
    let prefix;

    if (['e', 'f'].includes(addressType)) {
        if (networkId === NetworkId.MAINNET) {
            prefix = 'stake';
        } else if (networkId === NetworkId.TESTNET) {
            prefix = 'stake_test';
        } else {
            throw new TypeError('Unsupported network type');
        }

        return bech32.encode(prefix, words, 1000);
    } else {
        if (networkId === NetworkId.MAINNET) {
            prefix = 'addr';
        } else if (networkId === NetworkId.TESTNET) {
            prefix = 'addr_test';
        } else {
            throw new TypeError('Unsupported network type');
        }

        return bech32.encode(prefix, words, 1000);
    }
};

export function getTransactionBuilder(): SerializationLib.TransactionBuilder {

    const linearFee = SerializationLib.LinearFee.new(
        SerializationLib.BigNum.from_str('44'),
        SerializationLib.BigNum.from_str('155381')
    );

    const txBuilderCfg = SerializationLib.TransactionBuilderConfigBuilder.new()
        .fee_algo(linearFee)
        .pool_deposit(SerializationLib.BigNum.from_str('500000000'))
        .key_deposit(SerializationLib.BigNum.from_str('2000000'))
        .max_value_size(4000)
        .max_tx_size(8000)
        .coins_per_utxo_byte(SerializationLib.BigNum.from_str('4310'))
        .build();
    const txBuilder = SerializationLib.TransactionBuilder.new(txBuilderCfg);

    return txBuilder
}

