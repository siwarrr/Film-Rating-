// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FilmRating {
    // Structure pour représenter un avis sur un film
    struct Review {
        uint8 stars; // Note de l'utilisateur (de 1 à 5 étoiles)
        bool credible; // Indique si l'avis est considéré comme crédible
    }

    // Mapping pour stocker les avis des utilisateurs pour chaque film
    mapping(address => mapping(uint256 => Review)) public filmReviews;

    // Tableau pour stocker les adresses des utilisateurs qui ont donné des avis
    address[] public usersWithReviews;

    // Fonction pour donner un avis sur un film
    function rateFilm(uint256 filmId, uint8 stars, bool isCredible) public {
        require(stars >= 1 && stars <= 5, "Invalid star rating");

        // Enregistrement de l'avis de l'utilisateur
        filmReviews[msg.sender][filmId] = Review(stars, isCredible);

        // Si l'utilisateur n'est pas déjà dans le tableau, l'ajouter
        if (!hasGivenReview(msg.sender)) {
            usersWithReviews.push(msg.sender);
        }
    }

    // Fonction pour vérifier si un utilisateur a donné un avis
    function hasGivenReview(address user) internal view returns (bool) {
        for (uint256 i = 0; i < usersWithReviews.length; i++) {
            if (usersWithReviews[i] == user) {
                return true;
            }
        }
        return false;
    }

    // Fonction pour calculer le score d'un film en fonction des avis
    function calculateFilmScore(uint256 filmId) public view returns (uint256) {
        uint256 totalStars;
        uint256 totalReviews;

        // Parcours de toutes les adresses d'utilisateurs qui ont donné un avis sur le film
        for (uint256 i = 0; i < usersWithReviews.length; i++) {
            address userAddress = usersWithReviews[i];

            Review memory review = filmReviews[userAddress][filmId];

            // Vérification de la crédibilité de l'avis
            if (review.credible) {
                totalStars += review.stars;
                totalReviews++;
            }
        }

        // Calcul du score moyen du film
        if (totalReviews > 0) {
            return totalStars / totalReviews;
        } else {
            return 0; // Aucun avis crédible n'a été donné
        }
    }
}
