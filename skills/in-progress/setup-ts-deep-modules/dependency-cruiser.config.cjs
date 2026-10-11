// @ts-check
// Imposição de módulos profundos (deep modules) com o dependency-cruiser.
//
// Cada pacote sob a raiz dos pacotes é um MÓDULO PROFUNDO: muito comportamento
// atrás de uma interface pequena. A SUPERFÍCIE PÚBLICA de um pacote são os ENTRY
// POINTS dele: os arquivos na raiz do pacote. A implementação vive em SUBPASTAS e é
// privada (por convenção `lib/` para a implementação e `tests/` para os testes,
// mas qualquer subpasta é privada). Um pacote pode expor vários entry points
// pequenos (index.ts, client.ts, server.ts, …); prefira isso a um único barrel
// index gigante.
//
// A única coisa que você deveria precisar editar aqui é PACKAGES_ROOT.

/** Onde os pacotes vivem. Um diretório filho imediato por pacote (plano, sem aninhamento). */
const PACKAGES_ROOT = "src/packages";

// --- padrões derivados (não precisa editar) ---------------------------------
const R = PACKAGES_ROOT;
/**
 * Os detalhes internos privados de um pacote: qualquer coisa dentro de uma subpasta.
 * Os arquivos da raiz do pacote são os entry points dele e NÃO casam aqui:
 * continuam importáveis de fora.
 */
const PACKAGE_INTERNALS = `^${R}/[^/]+/[^/]+/`;

/** @type {import('dependency-cruiser').IConfiguration} */
module.exports = {
  forbidden: [
    {
      name: "entrypoint-boundary-from-app",
      comment:
        "O código da aplicação/raiz pode importar os entry points de um pacote (os arquivos da raiz), mas nada dentro das subpastas.",
      severity: "error",
      from: { pathNot: `^${R}/` }, // quem importa NÃO está dentro de nenhum pacote
      to: { path: PACKAGE_INTERNALS },
    },
    {
      name: "entrypoint-boundary-across-packages",
      comment:
        "Os arquivos de um pacote se importam livremente, mas só alcançam OUTROS pacotes pelos entry points deles, nunca pelos detalhes internos.",
      severity: "error",
      // quem importa está dentro de um pacote ($1), mas não é um arquivo de teste
      from: { path: `^${R}/([^/]+)/`, pathNot: `^${R}/[^/]+/tests/` },
      to: {
        path: PACKAGE_INTERNALS,
        pathNot: `^${R}/$1/`, // mesmo pacote → liberdade dentro do pacote
      },
    },
    {
      name: "tests-through-entrypoints",
      comment:
        "Os testes de um pacote o exercitam pelos entry points, como todo mundo: podem importar os entry points de qualquer pacote e as próprias fixtures de tests/, mas nunca os detalhes internos de nenhum pacote, nem do próprio.",
      severity: "error",
      from: { path: `^${R}/([^/]+)/tests/` }, // um arquivo de teste, no pacote $1
      to: {
        path: PACKAGE_INTERNALS,
        pathNot: `^${R}/$1/tests/`, // fixtures do próprio tests/ → permitido
      },
    },
    {
      name: "tests-folder-is-private",
      comment:
        "A pasta tests/ de um pacote só é acessível a partir de testes: nada mais pode importar fixtures.",
      severity: "error",
      from: { pathNot: `^${R}/[^/]+/tests/` }, // quem importa não é um teste
      to: { path: `^${R}/[^/]+/tests/` },
    },
    {
      name: "no-circular",
      comment: "Nenhum ciclo de dependência. Restrinja a `^${R}/` se quiser permitir ciclos fora dos pacotes.",
      severity: "error",
      from: {},
      to: { circular: true },
    },

    // --- Camadas (opcional, desligado por padrão) -------------------------------
    // Esconder a interface controla COMO você importa (pelos entry points).
    // As camadas controlam QUAIS pacotes podem depender de quais. Adicione as suas
    // próprias regras aqui, ex.:
    //
    // {
    //   name: "ui-may-not-depend-on-billing",
    //   severity: "error",
    //   from: { path: `^${R}/ui/` },
    //   to:   { path: `^${R}/billing/` },
    // },
  ],
  options: {
    doNotFollow: { path: "node_modules" },
    tsConfig: { fileName: "tsconfig.json" },
    enhancedResolveOptions: {
      extensions: [".ts", ".tsx", ".js", ".jsx", ".json"],
    },
  },
};
