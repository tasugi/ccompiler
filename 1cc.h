
typedef struct Token Token;

typedef enum {
  ND_ADD,
  ND_SUB,
  ND_MUL,
  ND_DIV,
  ND_NUM,
  ND_EQ,
  ND_NE,  // Not Equal
  ND_LT,  // Less than
  ND_LE,  // Less than or equal
  ND_ASSIGN,  // =
  ND_LVAR,    // local variable
  ND_RETURN,  // return
  ND_IF, // if
  ND_WHILE, // while
  ND_FOR, // for
  ND_BLOCK, // {}
  ND_CALL, // function call
  ND_FUNC, // function definition
} NodeKind;

typedef struct Node Node;

// type of node in ast
typedef struct Node {
  NodeKind kind;
  struct Node *lhs;  // left hand side node
  struct Node *rhs;  // right hand side node
  int val;           // number if ty is ND_NUM
  int offset;         // used if kind == ND_LVAR

  struct Node *cond; // condition: if, while, for
  struct Node *then; // then, if
  struct Node *els; // else, if
  struct Node *body; //body: while, for
  struct Node *init; // init: for
  struct Node *inc;  // increment: for

  struct Node *stmts[100]; // block

  char *name[100]; // identifier name
  struct Node *args[10]; // function call
};

Token *tokenize(char *p);
void program();
void gen(Node *node);

void error(char *fmt, ...);
void error_at(char *loc, char *fmt, ...);

Token *token;
extern Node *code[];
