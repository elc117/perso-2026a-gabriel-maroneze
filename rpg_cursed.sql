-- 1. Tabela de Usuários
CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    senha TEXT NOT NULL
);

-- 2. Tabela Principal do Personagem [cite: 1-9, 12-15, 45-51]
CREATE TABLE personagens (
    id SERIAL PRIMARY KEY,
    usuario_id INTEGER REFERENCES usuarios(id),
    nome VARCHAR(100) NOT NULL,
    nacionalidade VARCHAR(50),
    profissao VARCHAR(50),
    idade INTEGER,
    sangrias INTEGER DEFAULT 0,
    discernimento INTEGER DEFAULT 0,
    reducao_dano INTEGER DEFAULT 0,
    sanidade INTEGER DEFAULT 0,
    defesa INTEGER DEFAULT 0,
    -- Atributos (Status)
    forca INTEGER DEFAULT 0,
    destreza INTEGER DEFAULT 0,
    resistencia INTEGER DEFAULT 0,
    vitalidade INTEGER DEFAULT 0,
    arcanismo INTEGER DEFAULT 0,
    matriz_sangue INTEGER DEFAULT 0
);

-- 3. Tabela de Perícias (Um para um com Personagem) [cite: 16-43]
CREATE TABLE pericias (
    personagem_id INTEGER PRIMARY KEY REFERENCES personagens(id),
    acrobacia INTEGER DEFAULT 0, adestramento INTEGER DEFAULT 0, atletismo INTEGER DEFAULT 0,
    atuacao INTEGER DEFAULT 0, conducao INTEGER DEFAULT 0, conhecimento INTEGER DEFAULT 0,
    diplomacia INTEGER DEFAULT 0, enganacao INTEGER DEFAULT 0, fortitude INTEGER DEFAULT 0,
    furtividade INTEGER DEFAULT 0, guerra INTEGER DEFAULT 0, iniciativa INTEGER DEFAULT 0,
    intimidacao INTEGER DEFAULT 0, intuicao INTEGER DEFAULT 0, investigacao INTEGER DEFAULT 0,
    jogatina INTEGER DEFAULT 0, ladinagem INTEGER DEFAULT 0, luta INTEGER DEFAULT 0,
    medicina INTEGER DEFAULT 0, nobreza INTEGER DEFAULT 0, percepcao INTEGER DEFAULT 0,
    pontaria INTEGER DEFAULT 0, pilotagem INTEGER DEFAULT 0, reflexos INTEGER DEFAULT 0,
    religiao INTEGER DEFAULT 0, reparos INTEGER DEFAULT 0, sobrevivencia INTEGER DEFAULT 0,
    vontade INTEGER DEFAULT 0
);

-- 4. Ataques (Limite de 4 no código Haskell) [cite: 10]
CREATE TABLE ataques (
    id SERIAL PRIMARY KEY,
    personagem_id INTEGER REFERENCES personagens(id),
    nome_ataque VARCHAR(100),
    dano VARCHAR(50)
);

-- 5. Inventário (Limite de 16 no código Haskell) [cite: 11]
CREATE TABLE inventario (
    id SERIAL PRIMARY KEY,
    personagem_id INTEGER REFERENCES personagens(id),
    nome_item VARCHAR(100)
);