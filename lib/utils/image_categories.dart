String getCategoryAsset(String categoryName) {
  switch (categoryName.toLowerCase()) {
    case "baju":
      return "assets/images/shirt.png";
    case "sepatu":
      return "assets/images/shoes.png";
    case "tas":
      return "assets/images/bag.png";
    default:
      return "assets/images/logo_default.png";
  }
}
