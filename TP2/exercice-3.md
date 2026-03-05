# Exercice 3 – Dépendances fonctionnelles et normalisation

---

## 1. Déduire des DF avec les axiomes d'Armstrong

**Relation :** R(A, B, C, D, E)  
**F = {A → B, C ; C, D → E ; B → D ; E → A}**

On réécrit F : A → BC, CD → E, B → D, E → A.

**Axiomes d'Armstrong :**
- **Réflexivité :** Si Y ⊆ X alors X → Y
- **Augmentation :** Si X → Y alors XZ → YZ
- **Transitivité :** Si X → Y et Y → Z alors X → Z

**DF déduites (au moins 16) :**

| # | DF | Justification |
|---|-----|---------------|
| 1 | A → A | Réflexivité |
| 2 | A → B | A → BC (décomposition) |
| 3 | A → C | A → BC (décomposition) |
| 4 | A → BC | Donnée |
| 5 | B → B | Réflexivité |
| 6 | B → D | Donnée |
| 7 | C → C | Réflexivité |
| 8 | CD → E | Donnée |
| 9 | D → D | Réflexivité |
| 10 | E → E | Réflexivité |
| 11 | E → A | Donnée |
| 12 | A → D | Transitivité : A → B, B → D |
| 13 | E → B | Transitivité : E → A, A → B |
| 14 | E → C | Transitivité : E → A, A → C |
| 15 | E → D | Transitivité : E → A → B → D |
| 16 | E → BC | Transitivité : E → A, A → BC |
| 17 | A → E | A → C, A → D ⇒ A → CD ; CD → E ⇒ A → E |

---

## 2. Fermeture, superclé et BCNF

**Relation :** R(A, B, C, D, E, F)  
**F = {A → B, C, D ; B, C → D, E ; B → D ; D → A}**

### (a) Fermetures B⁺ et {A, B}⁺

**B⁺ :**
- B → B (trivial)
- B → D (donnée)
- D → A (donnée) ⇒ B → A (transitivité)

Donc **B⁺ = {A, B, D}**.

**{A, B}⁺ :**
- A, B → A, B (trivial)
- A → B, C, D (donnée) ⇒ on obtient C, D
- B, C → D, E (donnée) : on a B et C ⇒ on obtient E
- Aucune DF ne fait apparaître F

Donc **{A, B}⁺ = {A, B, C, D, E}**.

### (b) {A, F} est une superclé

On a A → B, C, D, donc A⁺ ⊇ {A, B, C, D}. Avec B, C → D, E, on obtient E. Donc **A⁺ = {A, B, C, D, E}**.

F n’apparaît dans aucune DF, donc F ∈ {A, F}⁺ seulement si on l’ajoute explicitement.

**{A, F}⁺ = A⁺ ∪ {F} = {A, B, C, D, E, F} = R.**

Donc **{A, F} est une superclé** de R.

### (c) BCNF et décomposition

**Vérification BCNF :** Pour chaque DF X → Y, X doit être une superclé.

- A → BCD : A⁺ = {A,B,C,D,E} ≠ R ⇒ A n’est pas une superclé ⇒ **violation**
- BC → DE : BC⁺ ne contient pas F ⇒ **violation**
- B → D : B n’est pas une superclé ⇒ **violation**
- D → A : D n’est pas une superclé ⇒ **violation**

R n’est pas en BCNF. Décomposition proposée :

**Étape 1 :** Violation D → A (D n’est pas superclé)  
→ R₁(D, A) avec D → A  
→ R' = R − {A} = (B, C, D, E, F). Les DF projetées : B → D, BC → DE (A disparaît).  
On conserve aussi A → BCD et D → A via la jointure.

**Étape 2 :** Dans R', violation B → D  
→ R₂(B, D) avec B → D  
→ R'' = (B, C, E, F). DF : BC → E (D disparaît).

**Étape 3 :** Dans R'', BC → E. BC est-il une superclé de R'' ? BC⁺ dans R'' = {B, C, E}. F n’est dans aucune DF ⇒ la clé de R'' doit contenir F. Donc (BCF) ou (BF) ou (CF) selon les DF. En fait, dans R'', on n’a pas de DF impliquant F, donc toute superclé doit contenir F. BC n’est pas une superclé ⇒ **violation**.  
→ R₃(B, C, E) avec BC → E  
→ R₄(B, C, F) sans DF non triviales (ou R₄ = (A, F) pour garder le lien).

Reprenons de façon plus simple. Clés candidates : A et D sont équivalents (A ↔ D). F doit être dans toute clé. Donc (A, F) et (D, F) sont des superclés. Probablement (A, F) et (D, F) sont des clés candidates.

**Décomposition BCNF (une possibilité) :**

| Relation | Attributs | DF | Clé |
|----------|-----------|-----|-----|
| R₁ | (A, B, C, D) | A → BCD, D → A | A ou D |
| R₂ | (B, D) | B → D | B |
| R₃ | (B, C, E) | BC → E | BC |
| R₄ | (A, F) ou (F, …) | — | (A, F) |

En fait, pour préserver les DF et avoir une décomposition correcte, on procède ainsi :

1. **D → A** : R₁(D, A), R' = (B, C, D, E, F)
2. Dans R' : **B → D** : R₂(B, D), R'' = (B, C, E, F)
3. Dans R'' : **BC → E** : R₃(B, C, E), R₄ = (B, C, F)

R₄(B, C, F) n’a pas de DF (F n’apparaît nulle part). La jointure R₁ ⋈ R₂ ⋈ R₃ ⋈ R₄ redonne bien R.

Pour inclure F, on peut garder R₄(B, C, F) ou une relation (A, F) pour préserver la superclé. La décomposition minimale en BCNF :

- R₁(A, B, C, D) : A → BCD, D → A (A et D sont des clés)
- R₂(B, D) : B → D
- R₃(B, C, E) : BC → E
- R₄(A, F) : pas de DF, clé (A, F)

---

## 3. Décomposition avec ou sans perte

**Relation :** R(A, B, C, D, E)

### (a) Décomposition sans perte : R₁(A, B, C) et R₂(A, D, E)

**Critère :** Une décomposition R₁, R₂ est sans perte si et seulement si  
**(R₁ ∩ R₂) → R₁** ou **(R₁ ∩ R₂) → R₂**.

Ici **R₁ ∩ R₂ = {A}**.

Si A est une clé candidate de R (par exemple A → B, C, D, E), alors :
- A → (A, B, C) = R₁

Donc la condition est satisfaite et la décomposition est **sans perte**.

### (b) Décomposition avec perte : R₁(A, B, C) et R₂(C, D, E)

**R₁ ∩ R₂ = {C}**.

Pour que la décomposition soit sans perte, il faudrait **C → R₁** ou **C → R₂**, c’est-à-dire C → (A, B, C) ou C → (C, D, E). Si C ne détermine pas les autres attributs, cette condition n’est pas vérifiée.

**Exemple de perte :** Supposons R contient les tuples :

| A | B | C | D | E |
|---|---|---|---|---|
| a₁ | b₁ | c₁ | d₁ | e₁ |
| a₂ | b₂ | c₁ | d₂ | e₂ |

Projection sur R₁ : (a₁,b₁,c₁), (a₂,b₂,c₁)  
Projection sur R₂ : (c₁,d₁,e₁), (c₁,d₂,e₂)

Jointure naturelle sur C :

| A | B | C | D | E |
|---|---|---|---|---|
| a₁ | b₁ | c₁ | d₁ | e₁ |
| a₁ | b₁ | c₁ | d₂ | e₂ |
| a₂ | b₂ | c₁ | d₁ | e₁ |
| a₂ | b₂ | c₁ | d₂ | e₂ |

On obtient 4 tuples au lieu des 2 initiaux : des **tuples parasites** apparaissent. La décomposition est **avec perte**.
