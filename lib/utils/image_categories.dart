String getCategoryAsset(String categoryName) {
  switch (categoryName.toLowerCase()) {
    case "shirt":
      return "assets/images/shirt.png";
    case "shoes":
      return "assets/images/shoes.png";
    case "bag":
      return "assets/images/bag.png";
    case "cap":
      return "assets/images/topi_removebg.png";
    case "pants":
      return "assets/images/celana_removebg.png";
    default:
      return "assets/images/logo_default.png";
  }
}
