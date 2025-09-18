// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title CBDC Mochila Peru - Billetera Digital
 * @author Equipo Pagos Peru
 * @notice Este contrato implementa un token CBDC para el sistema de pagos peruano
 * @dev Versión simplificada de un token CBDC con funcionalidades básicas
 * @custom:security Solo el Banco Central puede emitir/quitar tokens
 * @custom:version 1.0.0
 */
contract CBDCMochila {
    
    /// @notice Nombre completo del token CBDC
    string public name = "CBDC Mochila Peru";
    
    /// @notice Símbolo del token (MCH)
    string public symbol = "MCH";
    
    /// @notice Número de decimales (2 para formato monetario)
    /// @dev 100 unidades = 1.00 sol peruano
    uint8 public decimals = 2;
    
    /// @notice Suministro total de tokens en circulación
    uint256 public totalSupply;
    
    /// @notice Dirección del Banco Central del Perú (administrador)
    /// @dev Solo esta dirección puede emitir y quemar tokens
    address public centralBank;
    
    /// @notice Mapeo de saldos por dirección
    /// @dev address => saldo en tokens
    mapping(address => uint256) private balances;
    
    /// @notice Mapeo de aprobaciones para gastos delegados
    /// @dev owner => spender => cantidad aprobada
    mapping(address => mapping(address => uint256)) private allowances;

    /**
     * @notice Evento emitido cuando se transfieren tokens
     * @param from Dirección que envía los tokens
     * @param to Dirección que recibe los tokens
     * @param amount Cantidad de tokens transferidos
     */
    event Transfer(address indexed from, address indexed to, uint256 amount);
    
    /**
     * @notice Evento emitido cuando se aprueba un gasto
     * @param owner Propietario de los tokens
     * @param spender Dirección autorizada para gastar
     * @param amount Cantidad aprobada para gastar
     */
    event Approval(address indexed owner, address indexed spender, uint256 amount);
    
    /**
     * @notice Evento emitido cuando se crean nuevos tokens
     * @param to Dirección que recibe los tokens nuevos
     * @param amount Cantidad de tokens creados
     */
    event Mint(address indexed to, uint256 amount);
    
    /**
     * @notice Evento emitido cuando se destruyen tokens
     * @param from Dirección de la cual se queman los tokens
     * @param amount Cantidad de tokens destruidos
     */
    event Burn(address indexed from, uint256 amount);

    /**
     * @notice Modificador que restringe acceso solo al Banco Central
     * @dev Revierte la transacción si no es ejecutada por el Banco Central
     */
    modifier onlyCentralBank() {
        require(msg.sender == centralBank, "Solo el Banco Central puede ejecutar esto");
        _;
    }

    /**
     * @notice Constructor del contrato CBDC
     * @dev Establece al deployer como el Banco Central
     */
    constructor() {
        centralBank = msg.sender;
    }

    // ========= FUNCIONES PRINCIPALES =========

    /**
     * @notice Consulta el saldo de tokens de una cuenta
     * @param account Dirección de la cuenta a consultar
     * @return Saldo de tokens de la cuenta especificada
     */
    function balanceOf(address account) public view returns (uint256) {
        return balances[account];
    }

    /**
     * @notice Transfiere tokens del remitente a otra dirección
     * @param to Dirección de destino
     * @param amount Cantidad de tokens a transferir
     * @return true si la transferencia fue exitosa
     * @dev Requiere que el remitente tenga suficientes fondos
     */
    function transfer(address to, uint256 amount) public returns (bool) {
        require(to != address(0), "Destino invalido");
        require(balances[msg.sender] >= amount, "Fondos insuficientes");
        
        balances[msg.sender] -= amount;
        balances[to] += amount;
        
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    /**
     * @notice Aprueba a otra dirección para gastar tokens en nombre del propietario
     * @param spender Dirección autorizada para gastar
     * @param amount Cantidad máxima que puede gastar
     * @return true si la aprobación fue exitosa
     * @dev Permite implementar pagos delegados y contratos DeFi
     */
    function approve(address spender, uint256 amount) public returns (bool) {
        allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    /**
     * @notice Transfiere tokens usando una aprobación previa
     * @param from Dirección propietaria de los tokens
     * @param to Dirección de destino
     * @param amount Cantidad a transferir
     * @return true si la transferencia fue exitosa
     * @dev Requiere aprobación previa del propietario
     */
    function transferFrom(address from, address to, uint256 amount) public returns (bool) {
        require(balances[from] >= amount, "Fondos insuficientes");
        require(allowances[from][msg.sender] >= amount, "Allowance insuficiente");
        
        balances[from] -= amount;
        balances[to] += amount;
        allowances[from][msg.sender] -= amount;
        
        emit Transfer(from, to, amount);
        return true;
    }

    /**
     * @notice Consulta la cantidad aprobada para gastar
     * @param owner Propietario de los tokens
     * @param spender Dirección autorizada
     * @return Cantidad que el spender puede gastar del owner
     */
    function allowance(address owner, address spender) public view returns (uint256) {
        return allowances[owner][spender];
    }

    // ========= FUNCIONES ESPECIALES CBDC =========

    /**
     * @notice Crea nuevos tokens CBDC (solo Banco Central)
     * @param to Dirección que recibirá los nuevos tokens
     * @param amount Cantidad de tokens a crear
     * @dev Solo puede ser ejecutada por el Banco Central
     * @dev Aumenta el suministro total de tokens
     */
    function mint(address to, uint256 amount) public onlyCentralBank {
        balances[to] += amount;
        totalSupply += amount;
        
        emit Mint(to, amount);
        emit Transfer(address(0), to, amount);
    }

    /**
     * @notice Destruye tokens existentes (solo Banco Central)
     * @param from Dirección de la cual se quemarán los tokens
     * @param amount Cantidad de tokens a destruir
     * @dev Solo puede ser ejecutada por el Banco Central
     * @dev Reduce el suministro total de tokens
     * @dev Requiere que la cuenta tenga suficientes fondos
     */
    function burn(address from, uint256 amount) public onlyCentralBank {
        require(balances[from] >= amount, "Fondos insuficientes");
        
        balances[from] -= amount;
        totalSupply -= amount;
        
        emit Burn(from, amount);
        emit Transfer(from, address(0), amount);
    }
}
