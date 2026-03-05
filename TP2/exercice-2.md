# Exercice 2 – Normalisation

## 1. R(A, B, C) avec F = {A → B ; B → C}

**Clé candidate :** A (car A → B et B → C, donc A détermine tous les attributs).

**Analyse :**
- **1NF :** ✓ Attributs atomiques.
- **2NF :** ✓ Pas de dépendance partielle (clé simple).
- **3NF :** ✗ Dépendance transitive : A → B → C. La DF B → C viole la 3NF (B n'est pas une clé, C n'est pas un attribut premier).

**Décomposition pour atteindre la BCNF :**

| Relation | Attributs | Dépendances fonctionnelles |
|----------|-----------|----------------------------|
| R₁       | (A, B)    | A → B                      |
| R₂       | (B, C)    | B → C                      |

**Forme la plus avancée :** BCNF (après décomposition).

---

## 2. R(A, B, C) avec F = {A → C ; A → B}

**Clé candidate :** A (car A détermine B et C).

**Analyse :**
- **1NF :** ✓ Attributs atomiques.
- **2NF :** ✓ Pas de dépendance partielle.
- **3NF :** ✓ Pas de dépendance transitive ; B et C dépendent directement de A.
- **BCNF :** ✓ Pour toute DF X → Y, X est une superclé (A est la clé).

**Décomposition :** Aucune nécessaire.

**Forme la plus avancée :** BCNF.

---

## 3. R(A, B, C) avec F = {A, B → C ; C → B}

**Clés candidates :** (A, B) et (A, C).
- (A, B) → C par la DF A, B → C.
- (A, C) → B par la DF C → B, donc (A, C) détermine tous les attributs.

**Analyse :**
- **1NF :** ✓ Attributs atomiques.
- **2NF :** ✓ Pas de dépendance partielle (B et C dépendent de la clé entière).
- **3NF :** ✓ Pour C → B : C n'est pas une superclé, mais B est un attribut premier (présent dans la clé (A, B)), donc la 3NF est respectée.
- **BCNF :** ✗ La DF C → B viole la BCNF (C n'est pas une superclé).

**Décomposition pour atteindre la BCNF :**

| Relation | Attributs | Dépendances fonctionnelles |
|----------|-----------|----------------------------|
| R₁       | (B, C)    | C → B                      |
| R₂       | (A, C)    | (A, C) est la clé           |

La DF A, B → C est préservée par la jointure : R₁ ⋈ R₂ sur C redonne (A, B, C).

**Forme la plus avancée :** BCNF (après décomposition).
