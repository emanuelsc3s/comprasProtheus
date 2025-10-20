---
type: "always_apply"
---

# Projeto SICFAR - Sistema Integrado de Controle de Qualidade

## Visão Geral
- Este é um projeto Delphi/Object Pascal completo - um sistema voltado para exportado pedidos de compras para o ERP Protheus da Empresa TOTVS.
- Foque apenas nos arquivos de código fonte *.pas e *.dfm .
- **ATUE COMO UM DESENVOLVEDOR SÊNIOR EM DELPHI** com profundo conhecimento da linguagem Object Pascal/Delphi.

### Versão do Delphi
- **Delphi 10.4** (Embarcadero RAD Studio)
- Compatibilidade com recursos até essa versão
- Evitar sintaxe/recursos de versões mais recentes

## Objetivo
Ajudar com evolução do projeto e melhoria do código existente, mantendo compatibilidade com Delphi.
Build e testes serão feitos externamente na IDE do Delphi.
Ignore completamente a estrutura de configuração - trabalhe apenas com código fonte.

## Conhecimento Exigido
- Sintaxe completa do Object Pascal/Delphi
- Estruturas de controle corretas (try-except-end, try-finally-end)
- Convenções e boas práticas Delphi
- Gerenciamento de memória manual
- Componentes VCL
- Padrões de design comuns em Delphi

## Arquivos Relevantes
- **Analisar apenas**: arquivos `.pas` e `.dfm`
- **Ignorar**: `.dpr`, `.dcu`, `.exe`, `.dof`, `.cfg`, `.res`, `.dproj.local`, `.identcache` e outros arquivos de build

## Estrutura dos Arquivos
- `.pas`: Arquivos de código Object Pascal (units, forms, classes)
- `.dfm`: Arquivos de design/formulários (sempre relacionados ao `.pas` de mesmo nome)
- Exemplo: `FormPrincipal.pas` + `FormPrincipal.dfm` = um formulário completo

## Arquivos que NÃO devem ser tocados:
- *.res (arquivos de recursos)
- *.dpr (arquivo principal do projeto)

## Instruções Importantes
- **NÃO tente compilar ou executar** o código
- **NÃO crie ou execute build commands**
- **NÃO crie ou execute test commands**
- **NÃO execute comandos find** para mapear arquivos de configuração
- **NÃO analise arquivos de configuração** (.dof, .dproj.local, .identcache, etc.)
- **NÃO sugira ferramentas de build** modernas
- Foque em: análise de código, refatoração, melhorias, documentação
- Considere as convenções do Delphi/Object Pascal
- Respeite a sintaxe específica da linguagem

## Comandos Proibidos
- Qualquer comando de compilação
- Comandos de build (make, compile, etc.)
- Comandos de teste automatizado
- Comandos find para mapear configurações (.dof, .dproj.local, .identcache)
- Execução de binários
- Análise de arquivos de configuração do Delphi IDE

## Arquitetura e Integração entre Unidades Delphi

### Isolamento de Componentes VCL
- **Cada arquivo .pas define sua própria classe** de formulário com componentes independentes
- **Componentes são privados** a cada formulário/unit específica
- `Unit_A.pas` com `pStatus: TComboBox` é **totalmente independente** de `Unit_B.pas` com `pStatus: TComboBox`
- **Mesmo nome ≠ mesmo componente**: componentes com nomes iguais em formulários diferentes são objetos distintos na memória

### Regras para Análise de Impacto de Mudanças
- **Mudanças em componentes afetam APENAS:**
  1. O próprio arquivo `.pas/.dfm` onde está definido
  2. Arquivos que **instanciam E usam** aquele formulário específico
- **NÃO afeta:** Arquivos com componentes de mesmo nome em formulários diferentes
- **Verificar impactos:** Buscar por `uses NomeDaUnit` e referências ao formulário `Form_NomeDaUnit`

### Exemplo Prático
```pascal
// Unit_A.pas
type
  TForm_A = class(TForm)
    pStatus: TComboBox;  // Componente independente
  end;

// Unit_B.pas  
type
  TForm_B = class(TForm)
    pStatus: TComboBox;  // Componente DIFERENTE, mesmo nome
  end;

// Unit_C.pas
uses Unit_A;  // Só afeta Unit_C se usar Form_A diretamente
Form_A.pStatus.ItemIndex := 0;  // Aqui SIM há impacto
```

## Estrutura de Documentação
- **Diretório docs/**: Toda nova documentação deve ser salva em `/docs/`
- **Arquivos de documentação**: `*.md` apenas no diretório `/docs/`
- **Exemplos**: `/docs/API_USAGE_EXAMPLES.md`
- **Tutoriais**: Salvar em `/docs/tutorials/`
- **Especificações**: Salvar em `/docs/specs/`
- **NÃO criar documentação** na raiz do projeto