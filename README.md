# Pagos Perú - CBDC Modo Mochila

## 🏦 Descripción del Proyecto

**Pagos Perú** es una propuesta de billetera digital basada en CBDC (Central Bank Digital Currency) diseñada para facilitar pagos digitales en el Perú, especialmente en zonas rurales y para poblaciones no bancarizadas.

### 🎯 Características Principales

- **Billetera Modo Mochila**: Sistema de pagos offline para zonas sin conectividad
- **CBDC Peruano**: Moneda digital respaldada por el Banco Central
- **Inclusión Financiera**: Acceso a servicios financieros digitales
- **Límites Diarios**: Control de gastos y seguridad

## 🔧 Smart Contract - CBDCMochila

### Información Técnica

- **Nombre**: CBDC Mochila Peru
- **Símbolo**: MCH
- **Decimales**: 2 (formato monetario: 100 = 1.00 sol)
- **Red**: Ethereum Holesky Testnet
- **Dirección del Contrato**: `0x377...D2C1`

### 📋 Funcionalidades

#### 🏛️ **Funciones del Banco Central**
- `mint(address to, uint256 amount)` - Emitir nuevos tokens CBDC
- `burn(address from, uint256 amount)` - Quemar tokens existentes

#### 💰 **Funciones de Usuario**
- `transfer(address to, uint256 amount)` - Transferir tokens
- `approve(address spender, uint256 amount)` - Aprobar gastos
- `transferFrom(address from, address to, uint256 amount)` - Transferir con aprobación

#### 🔍 **Funciones de Consulta**
- `balanceOf(address account)` - Consultar saldo
- `allowance(address owner, address spender)` - Consultar aprobaciones
- `totalSupply()` - Suministro total de tokens

## 🚀 Despliegue y Pruebas

### Herramientas Utilizadas
- **Remix IDE**: Desarrollo y despliegue
- **Solidity**: v0.8.20+
- **MetaMask**: Wallet para interacciones
- **Holesky Testnet**: Red de pruebas Ethereum

### ✅ Pruebas Realizadas

1. **Compilación exitosa** con Solidity latest
2. **Despliegue exitoso** en Holesky testnet
3. **Emisión de tokens** (mint) - 1000 MCH
4. **Transferencias** entre cuentas
5. **Consultas de saldo** y información del contrato
6. **Conexión con MetaMask** funcionando

## 📊 Casos de Uso

### 🏪 **Comercio Local**
- Pagos en tiendas rurales
- Transacciones sin internet (modo offline)
- Límites diarios para seguridad

### 🎓 **Educación Financiera**
- Monedero escolar para estudiantes
- Control parental de gastos
- Aprendizaje de finanzas digitales

### 🌾 **Sector Rural**
- Pagos agrícolas
- Remesas familiares
- Inclusión de poblaciones no bancarizadas

## 🔐 Seguridad

- **Control centralizado**: Solo el Banco Central puede emitir/quemar tokens
- **Validaciones**: Verificación de saldos y direcciones
- **Límites**: Control de montos por transacción
- **Auditoría**: Todas las transacciones registradas en blockchain

## 📈 Roadmap Futuro

- [ ] Implementar funcionalidad offline real
- [ ] Integrar con sistemas bancarios peruanos
- [ ] Desarrollar aplicación móvil
- [ ] Piloto en comunidades rurales
- [ ] Integración con DNI digital

## 👥 Equipo de Desarrollo

**Proyecto de Innovación Blockchain**
- Desarrollo: Favio Huaman
- Institución: IEP Vallegrande
- Fecha: Septiembre 2025

## 📞 Contacto

Para más información sobre este proyecto de innovación blockchain:
- Email: favio.huaman@vallegrande.edu.pe
- GitHub: FaviohuamanVG

---

*Este proyecto es una propuesta académica para demostrar el potencial de las CBDC en el sistema financiero peruano.*
