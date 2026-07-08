String imagenPorEspecie(String especie) {
  switch (especie) {
    case 'gato':
      return 'https://cdn2.thecatapi.com/images/MjAxMDc4OA.jpg';
    case 'perro':
      return 'https://images.dog.ceo/breeds/terrier-silky/n02097658_9136.jpg';
    default:
      return 'https://images.dog.ceo/breeds/gaddi-indian/Gaddi.jpg';
  }
}
