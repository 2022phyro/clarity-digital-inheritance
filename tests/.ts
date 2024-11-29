import {
    Clarinet,
    Tx,
    Chain,
    Account,
    types
} from 'https://deno.land/x/clarinet@v1.0.0/index.ts';
import { assertEquals } from 'https://deno.land/std@0.90.0/testing/asserts.ts';

Clarinet.test({
    name: "Test creating inheritance",
    async fn(chain: Chain, accounts: Map<string, Account>) {
        const deployer = accounts.get('deployer')!;
        const beneficiary = accounts.get('wallet_1')!;
        
        let block = chain.mineBlock([
            Tx.contractCall('inheritance-vault', 'create-inheritance', [
                types.principal(beneficiary.address),
                types.uint(1000),
                types.uint(100)
            ], deployer.address)
        ]);
        
        block.receipts[0].result.expectOk();
    }
});

Clarinet.test({
    name: "Test proof of life",
    async fn(chain: Chain, accounts: Map<string, Account>) {
        const deployer = accounts.get('deployer')!;
        
        let block = chain.mineBlock([
            Tx.contractCall('inheritance-vault', 'prove-life', [], deployer.address)
        ]);
        
        block.receipts[0].result.expectOk();
    }
});

Clarinet.test({
    name: "Test claiming inheritance - should fail when owner is alive",
    async fn(chain: Chain, accounts: Map<string, Account>) {
        const deployer = accounts.get('deployer')!;
        const beneficiary = accounts.get('wallet_1')!;
        
        // Setup inheritance
        let block = chain.mineBlock([
            Tx.contractCall('inheritance-vault', 'create-inheritance', [
                types.principal(beneficiary.address),
                types.uint(1000),
                types.uint(100)
            ], deployer.address),
            Tx.contractCall('inheritance-vault', 'prove-life', [], deployer.address)
        ]);
        
        // Try to claim before deadline
        let claimBlock = chain.mineBlock([
            Tx.contractCall('inheritance-vault', 'claim-inheritance', [
                types.principal(deployer.address)
            ], beneficiary.address)
        ]);
        
        claimBlock.receipts[0].result.expectErr();
    }
});
