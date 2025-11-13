/*  Objetivo do Contrato
-- Criar um cofrinho digital onde o usuário pode:
-- Criar seu cofrinho.
-- Depositar tokens SUI.
-- Só sacar após uma data (ou epoch) específica. */

module savings_vault::vault {

    use std::option;
    use sui::balance;
    use sui::balance::Balance;
    use sui::coin;
    use sui::coin::Coin;
    use sui::sui::SUI;
    use sui::transfer;
    use sui::tx_context;
    use sui::tx_context::TxContext;
    use sui::object;
    use sui::object::UID;

    /// Estrutura principal do cofrinho
    public struct Vault has key {
        id: UID,
        owner: address,
        balance: Balance<SUI>,
        unlock_epoch: u64,
    }
    

    /// Cria um novo cofrinho, com uma epoch de desbloqueio
    public entry fun create_vault(unlock_epoch: u64, ctx: &mut TxContext) {
    let sender = tx_context::sender(ctx);

    let vault = Vault {
        id: object::new(ctx),
        owner: sender,
        balance: balance::zero<SUI>(),  // começa com saldo zero
        unlock_epoch,
        };

        transfer::transfer(vault, sender);
    }

    /// Deposita SUI no cofrinho (somente o dono do smart contract)
    public entry fun deposit(vault: &mut Vault, payment: Coin<SUI>, ctx: &mut TxContext) {
        let sender = tx_context::sender(ctx);
        assert!(sender == vault.owner, 0);

        let amount = coin::value(&payment);
        assert!(amount > 0, 1);

        let payment_balance = coin::into_balance(payment);
        balance::join(&mut vault.balance, payment_balance);
    }

    /// Retira todo o dinheiro do cofrinho se o tempo já passou
    public entry fun withdraw(vault: &mut Vault, ctx: &mut TxContext) {
        let sender = tx_context::sender(ctx);
        assert!(sender == vault.owner, 1);

        let current_epoch = tx_context::epoch(ctx);
        assert!(current_epoch >= vault.unlock_epoch, 2);

        // Move o balance e substitui por um novo vazio
        let amount = balance::value(&vault.balance);  
        let balance_to_withdraw = balance::split(&mut vault.balance, amount); 
        let coin_out = coin::from_balance(balance_to_withdraw, ctx);

    transfer::public_transfer(coin_out, vault.owner);

    }

    /// Consulta o saldo do cofrinho (função de leitura)
    public fun get_balance(vault: &Vault): u64 {
        balance::value(&vault.balance)
    }
}
