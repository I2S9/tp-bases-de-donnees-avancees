"""
Exercice 4 - TP2 : Dépendances fonctionnelles et fermeture d'attributs

Structures de données :
- Relations : liste de listes (chaque élément = ensemble d'attributs)
- Dépendances : liste de paires [alpha, beta] où alpha et beta sont des ensembles
"""

import itertools

# Exemple de données
myrelations = [
    ['A', 'B', 'C', 'G', 'H', 'I'],
    ['X', 'Y']
]

mydependencies = [
    [{'A'}, {'B'}],           # A -> B
    [{'A'}, {'C'}],           # A -> C
    [{'C', 'G'}, {'H'}],      # CG -> H
    [{'C', 'G'}, {'I'}],      # CG -> I
    [{'B'}, {'H'}]            # B -> H
]


def print_dependencies(F: list) -> None:
    """Affiche une liste de dépendances fonctionnelles."""
    for alpha, beta in F:
        print("\t", alpha, "-->", beta)


def print_relations(T: list) -> None:
    """Affiche un ensemble de relations."""
    for R in T:
        print("\t", R)


def power_set(input_set) -> list:
    """
    Retourne tous les sous-ensembles de input_set (P(E)).
    input_set peut être une liste ou un ensemble.
    """
    s = list(input_set)
    result = [set()]  # inclut l'ensemble vide
    for r in range(1, len(s) + 1):
        result.extend(map(set, itertools.combinations(s, r)))
    return result


def closure(K: set, F: list) -> set:
    """
    Calcule la fermeture K+ de l'ensemble d'attributs K
    par rapport aux dépendances fonctionnelles F.

    Algorithme : on applique les DF tant qu'on peut ajouter des attributs.
    """
    result = set(K)
    changed = True
    while changed:
        changed = False
        for alpha, beta in F:
            if alpha <= result and not (beta <= result):
                result |= beta
                changed = True
    return result


# --- Tests ---
if __name__ == "__main__":
    print("=== Dépendances fonctionnelles ===")
    print_dependencies(mydependencies)

    print("\n=== Relations ===")
    print_relations(myrelations)

    print("\n=== Sous-ensembles de {'A', 'B', 'C'} ===")
    print(power_set({'A', 'B', 'C'}))

    print("\n=== Fermeture de {'A'} ===")
    print(closure({'A'}, mydependencies))  # A+ = {A, B, C, H} (A->B, A->C, B->H)

    print("\n=== Fermeture de {'A', 'G'} ===")
    print(closure({'A', 'G'}, mydependencies))  # {A,G}+ = {A, B, C, G, H, I}
