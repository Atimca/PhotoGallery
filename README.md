# PhotoGallery

There are three examples of my code:
1) [With architectural approach and clean code](https://github.com/Atimca/Currencies)
2) **[Regarding to one screen task with the `KISS` principle](https://github.com/Atimca/PhotoGallery)**
3) [Just a task written on Objective-C](https://github.com/Atimca/EmployeeSalaries)

**Task:**

Create a simple album list, photo list and photo detail application, using data from:
https://jsonplaceholder.typicode.com

**Tech stack:**

- `DataDriven` pattern for working with views  
- Plain `URLSession` for networking  
- `Kingfisher` for image downloading

**Disclamer:**

The task was easy, so I've decided to make it as easy as possible, using the `KISS` principle. If you want to see heavy approach, use a link in the top. However, I don't forget about extensibility and use some rules for it. I separated layers of business and view. Also, I didn't create hundreds of helper classes, because they don't need for this task. I just tried to separate all code with extensions. This approach gives a possibility to move code into other entities.  I used only one library for image downloading because write it by yourself is overhead.
