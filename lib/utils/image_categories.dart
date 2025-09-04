String getCategoryAsset(String categoryName) {
  switch (categoryName.toLowerCase()) {
    case "baju":
      return "assets/images/shirt.png";
    case "sepatu":
      return "assets/images/shoes.png";
    case "tas":
      return "assets/images/bag.png";
    case "topi":
      return "assets/images/topi_removebg.png";
    case "celana":
      return "assets/images/celana_removebg.png";
    default:
      return "assets/images/logo_default.png";
  }
}
