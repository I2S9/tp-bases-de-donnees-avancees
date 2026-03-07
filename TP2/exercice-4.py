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
    """
    return compute_attribute_closure(F, K)


def compute_attribute_closure(F: list, K: set) -> set:
    """
    Calcule la fermeture K+ de l'ensemble d'attributs K
    par rapport aux dépendances fonctionnelles F.
    """
    k_plus = set(K)
    changed = True
    while changed:
        changed = False
        for alpha, beta in F:
            if alpha <= k_plus and not (beta <= k_plus):
                k_plus |= beta
                changed = True
    return k_plus


def compute_dependencies_closure(F: list) -> list:
    """
    Retourne la clôture F+ de F : toutes les DF déductibles de F.
    Pour chaque sous-ensemble K des attributs, on calcule K+ et on ajoute K -> beta
    pour tout beta inclus dans K+.
    """
    R = set()
    for alpha, beta in F:
        R |= alpha | beta
    f_plus = []
    for K in power_set(R):
        k_plus = compute_attribute_closure(F, K)
        for beta in power_set(k_plus):
            if beta:  # exclure les DF triviales K -> {}
                f_plus.append([K, beta])
    return f_plus


def is_dependency(F: list, alpha: set, beta: set) -> bool:
    """Retourne True si alpha détermine fonctionnellement beta."""
    return beta <= compute_attribute_closure(F, alpha)


def is_super_key(F: list, R, K: set) -> bool:
    """Retourne True si K est une super-clé de la relation R."""
    R_set = set(R)
    return R_set <= compute_attribute_closure(F, K)


def is_candidate_key(F: list, R, K: set) -> bool:
    """Retourne True si K est une clé candidate de la relation R."""
    if not is_super_key(F, R, K):
        return False
    for A in K:
        k1 = K - {A}
        if is_super_key(F, R, k1):
            return False  # K n'est pas minimal
    return True


def compute_all_candidate_keys(F: list, R) -> list:
    """Retourne la liste de toutes les clés candidates de R."""
    R_set = set(R)
    result = []
    for K in power_set(R_set):
        if is_candidate_key(F, R, K):
            result.append(K)
    return result


def compute_all_super_keys(F: list, R) -> list:
    """Retourne la liste de toutes les super-clés de R."""
    R_set = set(R)
    result = []
    for K in power_set(R_set):
        if is_super_key(F, R, K):
            result.append(K)
    return result


def is_bcnf_relation(F: list, R) -> tuple:
    """
    Retourne (True, {}) si R est en BCNF, sinon (False, [alpha, beta])
    pour la DF alpha -> beta qui viole la BCNF.
    """
    R_set = set(R)
    for alpha, beta in F:
        if alpha <= R_set and beta <= R_set and (beta - alpha):
            if not is_super_key(F, R, alpha):
                return False, [alpha, beta]
    return True, {}


def is_bcnf_relations(F: list, T: list) -> tuple:
    """
    Retourne (True, {}) si le schéma T est en BCNF, sinon (False, R)
    pour la relation R qui viole la BCNF.
    """
    for R in T:
        ok, violation = is_bcnf_relation(F, R)
        if not ok:
            return False, set(R)
    return True, {}


def compute_bcnf_decomposition(F: list, T: list) -> list:
    """
    Implémente l'algorithme de décomposition en BCNF.
    Retourne la liste des relations après décomposition.
    """
    OUT = [set(R) for R in T]
    size = 0
    while size != len(OUT):
        size = len(OUT)
        for R in list(OUT):
            ok, violation = is_bcnf_relation(F, R)
            if not ok:
                alpha, beta = violation
                R1 = alpha | beta
                R2 = R - beta
                if R1 not in OUT:
                    OUT.append(R1)
                if R2 and R2 not in OUT:
                    OUT.append(R2)
                OUT.remove(R)
                break
    return OUT


# --- Tests ---
if __name__ == "__main__":
    print("=== Dépendances fonctionnelles ===")
    print_dependencies(mydependencies)

    print("\n=== Relations ===")
    print_relations(myrelations)

    print("\n=== Sous-ensembles de {'A', 'B', 'C'} ===")
    print(power_set({'A', 'B', 'C'}))

    print("\n=== Fermeture de {'A'} ===")
    print(closure({'A'}, mydependencies))

    print("\n=== Fermeture de {'A', 'G'} ===")
    print(closure({'A', 'G'}, mydependencies))

    # Relation R = premier schéma
    R = set(myrelations[0])
    print("\n=== Super-clés de R(A,B,C,G,H,I) ===")
    super_keys = compute_all_super_keys(mydependencies, R)
    print(f"Nombre: {len(super_keys)}")
    for sk in super_keys[:5]:
        print("\t", sk)
    if len(super_keys) > 5:
        print("\t...")

    print("\n=== Clés candidates de R ===")
    candidate_keys = compute_all_candidate_keys(mydependencies, R)
    for ck in candidate_keys:
        print("\t", ck)

    print("\n=== Test is_dependency: A détermine H ? ===")
    print(is_dependency(mydependencies, {'A'}, {'H'}))

    print("\n=== Schéma en BCNF ? ===")
    ok, viol = is_bcnf_relations(mydependencies, myrelations)
    print(f"is_bcnf_relations: {ok}", f"(relation violante: {viol})" if not ok else "")

    print("\n=== Décomposition BCNF de R(A,B,C,G,H,I) ===")
    decomp = compute_bcnf_decomposition(mydependencies, [myrelations[0]])
    for i, rel in enumerate(decomp):
        print(f"\tR{i+1}: {sorted(rel)}")
