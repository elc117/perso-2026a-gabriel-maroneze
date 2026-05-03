-- ============================================================================
-- Cursed RPG — schema do banco
-- Refinamento do SQL original com:
--   • campos faltantes do PDF (vida, altura, tom_pele, cor_olhos, cabelo,
--     manipulação de sangue: acesso_rapido e descricoes)
--   • perícias customizadas (4 linhas em branco do PDF)
--   • tabela de histórico de versões (snapshots JSONB)
-- ============================================================================

-- 1. Usuários ----------------------------------------------------------------
-- Sem hash por opção do projeto (uso amador entre amigos).
-- A parametrização do postgresql-simple já protege contra SQL injection.
CREATE TABLE usuarios (
    id       SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    senha    TEXT NOT NULL
);

-- 2. Personagem (linha "espinha dorsal") -------------------------------------
CREATE TABLE personagens (
    id              SERIAL PRIMARY KEY,
    usuario_id      INTEGER NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    nome            VARCHAR(100) NOT NULL,

    -- Header da ficha
    sangrias        INTEGER NOT NULL DEFAULT 0,
    discernimento   INTEGER NOT NULL DEFAULT 0,

    -- Status (lado direito da página 1)
    vida            INTEGER NOT NULL DEFAULT 0,
    sanidade        INTEGER NOT NULL DEFAULT 0,
    reducao_dano    INTEGER NOT NULL DEFAULT 0,
    defesa          INTEGER NOT NULL DEFAULT 0,

    -- Atributos (pentágonos da esquerda)
    forca           INTEGER NOT NULL DEFAULT 0,
    destreza        INTEGER NOT NULL DEFAULT 0,
    resistencia     INTEGER NOT NULL DEFAULT 0,
    vitalidade      INTEGER NOT NULL DEFAULT 0,
    arcanismo       INTEGER NOT NULL DEFAULT 0,
    matriz_sangue   INTEGER NOT NULL DEFAULT 0,

    -- Características (página 2)
    nacionalidade   VARCHAR(100) NOT NULL DEFAULT '',
    profissao       VARCHAR(100) NOT NULL DEFAULT '',
    idade           INTEGER,
    altura          VARCHAR(50)  NOT NULL DEFAULT '',
    tom_pele        VARCHAR(50)  NOT NULL DEFAULT '',
    cor_olhos       VARCHAR(50)  NOT NULL DEFAULT '',
    cabelo          VARCHAR(100) NOT NULL DEFAULT '',

    -- Manipulação de Sangue (página 2)
    acesso_rapido   TEXT NOT NULL DEFAULT '',
    descricoes      TEXT NOT NULL DEFAULT '',

    -- Auditoria
    criada_em       TIMESTAMP NOT NULL DEFAULT NOW(),
    atualizada_em   TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_personagens_usuario ON personagens(usuario_id);

-- 3. Perícias (1-1 com personagem) -------------------------------------------
CREATE TABLE pericias (
    personagem_id  INTEGER PRIMARY KEY REFERENCES personagens(id) ON DELETE CASCADE,
    acrobacia      INTEGER NOT NULL DEFAULT 0,
    adestramento   INTEGER NOT NULL DEFAULT 0,
    atletismo      INTEGER NOT NULL DEFAULT 0,
    atuacao        INTEGER NOT NULL DEFAULT 0,
    conducao       INTEGER NOT NULL DEFAULT 0,
    conhecimento   INTEGER NOT NULL DEFAULT 0,
    diplomacia     INTEGER NOT NULL DEFAULT 0,
    enganacao      INTEGER NOT NULL DEFAULT 0,
    fortitude      INTEGER NOT NULL DEFAULT 0,
    furtividade    INTEGER NOT NULL DEFAULT 0,
    guerra         INTEGER NOT NULL DEFAULT 0,
    iniciativa     INTEGER NOT NULL DEFAULT 0,
    intimidacao    INTEGER NOT NULL DEFAULT 0,
    intuicao       INTEGER NOT NULL DEFAULT 0,
    investigacao   INTEGER NOT NULL DEFAULT 0,
    jogatina       INTEGER NOT NULL DEFAULT 0,
    ladinagem      INTEGER NOT NULL DEFAULT 0,
    luta           INTEGER NOT NULL DEFAULT 0,
    medicina       INTEGER NOT NULL DEFAULT 0,
    nobreza        INTEGER NOT NULL DEFAULT 0,
    percepcao      INTEGER NOT NULL DEFAULT 0,
    pontaria       INTEGER NOT NULL DEFAULT 0,
    pilotagem      INTEGER NOT NULL DEFAULT 0,
    reflexos       INTEGER NOT NULL DEFAULT 0,
    religiao       INTEGER NOT NULL DEFAULT 0,
    reparos        INTEGER NOT NULL DEFAULT 0,
    sobrevivencia  INTEGER NOT NULL DEFAULT 0,
    vontade        INTEGER NOT NULL DEFAULT 0
);

-- 4. Perícias customizadas (4 linhas em branco no PDF, sem teto rígido) -----
CREATE TABLE pericias_customizadas (
    id             SERIAL PRIMARY KEY,
    personagem_id  INTEGER NOT NULL REFERENCES personagens(id) ON DELETE CASCADE,
    nome           VARCHAR(100) NOT NULL,
    valor          INTEGER NOT NULL DEFAULT 0
);

CREATE INDEX idx_pericias_custom_personagem ON pericias_customizadas(personagem_id);

-- 5. Ataques (limite de 4 imposto pelo backend) -----------------------------
CREATE TABLE ataques (
    id             SERIAL PRIMARY KEY,
    personagem_id  INTEGER NOT NULL REFERENCES personagens(id) ON DELETE CASCADE,
    nome_ataque    VARCHAR(100) NOT NULL,
    dano           VARCHAR(50)  NOT NULL DEFAULT ''
);

CREATE INDEX idx_ataques_personagem ON ataques(personagem_id);

-- 6. Inventário (limite de 16 imposto pelo backend) -------------------------
CREATE TABLE inventario (
    id             SERIAL PRIMARY KEY,
    personagem_id  INTEGER NOT NULL REFERENCES personagens(id) ON DELETE CASCADE,
    nome_item      VARCHAR(100) NOT NULL
);

CREATE INDEX idx_inventario_personagem ON inventario(personagem_id);

-- 7. Histórico de versões (snapshot JSONB) ----------------------------------
-- Sem FK em personagem_id de propósito: queremos preservar o histórico mesmo
-- após o personagem ser deletado (recuperação de DELETE acidental).
-- O backend mantém só os 10 mais recentes por ficha; a função
-- limparHistoricoAntigo cuida disso.
CREATE TABLE historico_fichas (
    id             SERIAL PRIMARY KEY,
    personagem_id  INTEGER NOT NULL,
    snapshot       JSONB   NOT NULL,
    motivo         VARCHAR(20) NOT NULL DEFAULT 'update', -- 'update' ou 'delete'
    salvo_em       TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_historico_personagem ON historico_fichas(personagem_id, salvo_em DESC);
