-- ============================================================================
-- SCRIPT 02: CONSULTAS (DQL), SEGURANÇA (DCL) E BACKUP
-- Projeto: BancoAcademia
-- ============================================================================

USE `BancoAcademia`;

-- ----------------------------------------------------------------------------
-- 1. CONSULTAS E RELATÓRIOS (DQL)
-- ----------------------------------------------------------------------------

-- Consulta 1: Relatório de Alunos e seus respectivos Planos
SELECT 
    A.nome AS Aluno,
    A.cpf AS CPF,
    A.telefone AS Telefone,
    CONCAT('R$ ', FORMAT(P.valor, 2, 'pt_BR')) AS Valor_Plano
FROM alunos A
INNER JOIN planos P ON A.planos_id_plano = P.id_plano;

-- Consulta 2: Relatório de Turmas, Horários e seus Instrutores
SELECT 
    T.nome_atividade AS Atividade,
    T.horario AS Horario,
    T.dias_semana AS Dia_da_Semana,
    I.nome AS Instrutor
FROM turmas T
INNER JOIN instrutores I ON T.instrutores_id_instrutor = I.id_instrutor;

-- Consulta 3: Relatório Geral de Matrículas (Visão Completa das 5 Tabelas)
SELECT 
    M.id_matricula AS Matricula,
    A.nome AS Aluno,
    P.nome AS Plano,
    T.nome_atividade AS Turma,
    I.nome AS Instrutor
FROM matriculas M
INNER JOIN alunos A ON M.alunos_id_aluno = A.id_aluno
INNER JOIN planos P ON A.planos_id_plano = P.id_plano
INNER JOIN turmas T ON M.turmas_id_turma = T.id_turma
INNER JOIN instrutores I ON T.instrutores_id_instrutor = I.id_instrutor;

-- Consulta 4: Métrica de Total de Alunos por Plano (Agrupamento e Agregação)
SELECT 
    P.nome AS Plano,
    COUNT(A.id_aluno) AS Total_Alunos
FROM planos P
LEFT JOIN alunos A ON P.id_plano = A.planos_id_plano
GROUP BY P.id_plano, P.nome;


-- ----------------------------------------------------------------------------
-- 2. GERENCIAMENTO DE ACESSOS E SEGURANÇA (DCL)
-- ----------------------------------------------------------------------------

-- Criação do usuário para recepção
CREATE USER IF NOT EXISTS 'recepcao'@'localhost' IDENTIFIED BY 'SenhaRecepcao123!';

-- Concessão de permissões específicas para o perfil de atendimento
GRANT SELECT, INSERT, UPDATE ON BancoAcademia.alunos TO 'recepcao'@'localhost';
GRANT SELECT, INSERT, UPDATE ON BancoAcademia.matriculas TO 'recepcao'@'localhost';

-- Atualização das permissões (Comentado para evitar falha na engine Aria local):
-- FLUSH PRIVILEGES;


-- ----------------------------------------------------------------------------
-- 3. COMANDOS DE BACKUP E RESTAURAÇÃO (Prompt de Comando / Terminal)
-- ----------------------------------------------------------------------------

-- Comando de Exportação (Backup do Banco Completo):
-- mysqldump -u root -p BancoAcademia > C:\backups\backup_academia.sql

-- Comando de Importação (Restauração do Banco):
-- mysql -u root -p BancoAcademia < C:\backups\backup_academia.sql