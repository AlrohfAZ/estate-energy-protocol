<!--
1. PROTOCOL PURPOSE:
    This is a v0.1 protocol that models abstract energy production, transfer, and usage accounting using a single estate as the specimen.
    There are 3 roles: Producer, Consumer, and Both.
    A house may act as both Producer and Consumer.
    The producer will submit production claims, which will then be validated, and minted as transferable energy tokens.
    Consumers buy the energy tokens and can convert it for usage at their discretion.
    Real-world metering is not covered in this protocol v0.1.

2. ACTORS:
    This protocol has 4 actors in v0.1: Admin, Oracle, Producer, Consumer.
    ADMIN: The admin approves and revokes roles for houses in the estate, and in v0.1 it also sets parametrs for the dailyTariffLimit
    and dailyMintCap, the admin can not mint or pprove minting.
    ORACLE: The oracle validates the claims of the producer, and approves minting, the oracle can not consume or trade energy tokens,
     it also converts produced energy into tokens, it also enforces the dailyTariffLimit and dailyMintCap.
    PRODUCER: This role produces energy which is converted to energy tokens by the oracle for minting, a house that it strictly a producer
     can not consume energy, this role can not directly mint energy, and can transfer EnergyTokens to approved houses.
    CONSUMER: This role buys the energy tokens, and can convert them to Usageunits for their meters, it can not validate producer claims,
     a house that is strictly a consumer can not produce energy or mint.

3. CORE INVARIANTS:
    A producer can not be credited more than once a day, basically, they can not submit multiplt production claims for minting approval.
    Only approvedHouses can hold or transfer EnergyToken.
    Only the admin can assign roles to houses.
    Only the oracle can approve minting.
    EnergyTokens converted into UsageUnits can not be RE-USED.
    Total minted EnergyTokens must never exceed the amount validated by the oracle.
    EnergyTokens can not be minted or transferred to houses that are not approved.

4. STATE AND LIFECYCLE:
    TOTAL ENERGY FLOW: PRODUCER -> ORACLE -> CONSUMER
    ENERGY PRODUCTION FLOW:
        1. The producers submits production claims.
        2. The oracle validates the claim, and triggers minting.
        3. Tokens are minted to producer.
    ENERGY CONSUMER FLOW:
        1. The consumer buys the EnergyTokens.
        2. The consumer converts the EnergyTokens to UsageUnits.
        3. The usage ledger(UsageUnitVault) record is updated.
        4. Usage of the units generates only record and not value.

5. UPGRADE AND VERSIONING STRATEGY:
    1. Multi-estate support may be considered.
    2. The system may be converted to support real world metering.
    3. The measure of time may be modified.
    4. Role and transfer constraints may be relaxed in the future.
 -->
