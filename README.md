# PhotoGallery

There are two examples of my code. One was made as easy as possible. And another one with all fancy architecture and testing. This is the first one, another you can get by [the link](https://github.com/Atimca/Currencies)

**Task:**

Create a simple album list, photo list and photo detail application, using data from:
https://jsonplaceholder.typicode.com

**Tech stack:**

- `DataDriven` pattern for working with views  
- Plain `URLSession` for networking  
- `Kingfisher` for image downloading

**Disclamer:**

The task was easy, so I've decided to make it as easy as possible, using the 'KISS' principle. If you want to see heavy approach, use a link in the top. However, I don't forget about extensibility and use some rules for it. I separated layers of business and view. Also, I didn't create hundreds of helper classes, because they don't need for this task. I just tried to separate all code with extensions. This approach gives a possibility to move code into other entities.  I used only one library for image downloading because write it by yourself is overhead.