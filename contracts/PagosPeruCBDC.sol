// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Versión simplificada de un token CBDC
// Solo el Banco Central puede emitir/quitar tokens
// Los usuarios transfieren entre sí libremente

contract CBDCMochila {
    string public name = "CBDC Mochila Peru";
    string public symbol = "MCH";
    uint8 public decimals = 2; // ejemplo: 2 decimales (1.00 soles)
    uint256 public totalSupply;

    address public centralBank; // Banco Central del Perú (admin)
    
    mapping(address => uint256) private balances;
    mapping(address => mapping(address => uint256)) private allowances;

    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Approval(address indexed owner, address indexed spender, uint256 amount);
    event Mint(address indexed to, uint256 amount);
    event Burn(address indexed from, uint256 amount);

    modifier onlyCentralBank() {
        require(msg.sender == centralBank, "Solo el Banco Central puede ejecutar esto");
        _;
    }

    constructor() {
        centralBank = msg.sender; // Quien despliega es el banco central
    }

    // ========= Core Functions ==========

    function balanceOf(address account) public view returns (uint256) {
        return balances[account];
    }

    function transfer(address to, uint256 amount) public returns (bool) {
        require(to != address(0), "Destino invalido");
        require(balances[msg.sender] >= amount, "Fondos insuficientes");
        balances[msg.sender] -= amount;
        balances[to] += amount;
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public returns (bool) {
        require(balances[from] >= amount, "Fondos insuficientes");
        require(allowances[from][msg.sender] >= amount, "Allowance insuficiente");
        balances[from] -= amount;
        balances[to] += amount;
        allowances[from][msg.sender] -= amount;
        emit Transfer(from, to, amount);
        return true;
    }

    function allowance(address owner, address spender) public view returns (uint256) {
        return allowances[owner][spender];
    }

    // ========= CBDC Special =========

    function mint(address to, uint256 amount) public onlyCentralBank {
        balances[to] += amount;
        totalSupply += amount;
        emit Mint(to, amount);
        emit Transfer(address(0), to, amount);
    }

    function burn(address from, uint256 amount) public onlyCentralBank {
        require(balances[from] >= amount, "Fondos insuficientes");
        balances[from] -= amount;
        totalSupply -= amount;
        emit Burn(from, amount);
        emit Transfer(from, address(0), amount);
    }
}
