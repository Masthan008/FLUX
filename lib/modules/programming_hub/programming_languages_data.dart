import 'package:flutter/material.dart';

/// Data model for a programming language topic
class LanguageTopic {
  final String title;
  final String content;
  final String? codeExample;
  final List<String> keyPoints;
  final List<String> shortcuts; // Quick tips & shortcuts

  const LanguageTopic({
    required this.title,
    required this.content,
    this.codeExample,
    this.keyPoints = const [],
    this.shortcuts = const [],
  });
}

/// Data model for a programming language
class ProgrammingLanguage {
  final String name;
  final String tagline;
  final String description;
  final IconData icon;
  final Color primaryColor;
  final Color secondaryColor;
  final String difficulty;
  final List<String> useCases;
  final List<LanguageTopic> topics;
  final String logoAsset;
  final int yearCreated;
  final String creator;

  const ProgrammingLanguage({
    required this.name,
    required this.tagline,
    required this.description,
    required this.icon,
    required this.primaryColor,
    required this.secondaryColor,
    required this.difficulty,
    required this.useCases,
    required this.topics,
    this.logoAsset = '',
    this.yearCreated = 0,
    this.creator = '',
  });
}

/// Repository for all programming languages data
class ProgrammingLanguagesRepository {
  static final List<ProgrammingLanguage> allLanguages = [
    // Python
    ProgrammingLanguage(
      name: 'Python',
      tagline: 'Simple yet Powerful',
      description: 'A versatile, beginner-friendly language known for its clean syntax and vast ecosystem.',
      icon: Icons.pest_control,
      primaryColor: const Color(0xFF3776AB),
      secondaryColor: const Color(0xFFFFD43B),
      difficulty: 'Beginner',
      yearCreated: 1991,
      creator: 'Guido van Rossum',
      useCases: ['Web Development', 'Data Science', 'Machine Learning', 'Automation', 'Scripting'],
      topics: [
        LanguageTopic(
          title: 'Basic Syntax & Variables',
          content: 'Python uses indentation for blocks. Variables are dynamically typed - no need to declare types.',
          codeExample: '''# Variables (no type declaration needed)
name = "Python"
age = 32
pi = 3.14159
is_awesome = True

# Multiple assignment
x, y, z = 1, 2, 3

# Print statement
print(f"Hello, {name}!")''',
          keyPoints: ['Dynamic typing', 'Indentation matters', 'f-strings for formatting'],
        ),
        LanguageTopic(
          title: 'Data Structures',
          content: 'Lists, tuples, dictionaries, and sets are the core data structures.',
          codeExample: '''# List (mutable, ordered)
fruits = ["apple", "banana", "cherry"]
fruits.append("date")

# Tuple (immutable, ordered)
coordinates = (10, 20)

# Dictionary (key-value pairs)
person = {"name": "Alice", "age": 25}

# Set (unique values)
unique_nums = {1, 2, 3, 3}  # {1, 2, 3}''',
          keyPoints: ['Lists are mutable', 'Tuples are immutable', 'Dicts use key-value pairs'],
        ),
        LanguageTopic(
          title: 'Functions & Lambda',
          content: 'Define reusable code blocks with def. Lambda for inline anonymous functions.',
          codeExample: '''# Regular function
def greet(name, greeting="Hello"):
    return f"{greeting}, {name}!"

# Lambda function
square = lambda x: x ** 2

# Higher-order functions
numbers = [1, 2, 3, 4, 5]
squared = list(map(lambda x: x**2, numbers))
evens = list(filter(lambda x: x%2==0, numbers))''',
          keyPoints: ['Default parameters', 'Lambda for short functions', 'map/filter/reduce'],
        ),
        LanguageTopic(
          title: 'Object-Oriented Programming',
          content: 'Classes, inheritance, encapsulation, and polymorphism in Python.',
          codeExample: '''class Animal:
    def __init__(self, name):
        self.name = name
    
    def speak(self):
        raise NotImplementedError

class Dog(Animal):
    def speak(self):
        return f"{self.name} says Woof!"

class Cat(Animal):
    def speak(self):
        return f"{self.name} says Meow!"

dog = Dog("Buddy")
print(dog.speak())  # Buddy says Woof!''',
          keyPoints: ['__init__ is constructor', 'self refers to instance', 'Inheritance with (Parent)'],
        ),
        LanguageTopic(
          title: 'List Comprehensions',
          content: 'Concise way to create lists based on existing lists.',
          codeExample: '''# Basic comprehension
squares = [x**2 for x in range(10)]

# With condition
evens = [x for x in range(20) if x % 2 == 0]

# Nested comprehension
matrix = [[i*j for j in range(3)] for i in range(3)]

# Dictionary comprehension
word_lengths = {word: len(word) for word in ["hello", "world"]}''',
          keyPoints: ['More Pythonic than loops', 'Can include conditions', 'Works for dicts too'],
        ),
        LanguageTopic(
          title: 'File Handling',
          content: 'Reading, writing, and managing files with context managers.',
          codeExample: '''# Reading a file
with open("file.txt", "r") as f:
    content = f.read()

# Writing to a file
with open("output.txt", "w") as f:
    f.write("Hello, World!")

# Reading line by line
with open("data.txt") as f:
    for line in f:
        print(line.strip())''',
          keyPoints: ['Use "with" for auto-closing', 'Modes: r, w, a, rb, wb', 'strip() removes newlines'],
        ),
        LanguageTopic(
          title: 'Exception Handling',
          content: 'Handle errors gracefully with try-except blocks.',
          codeExample: '''try:
    result = 10 / 0
except ZeroDivisionError as e:
    print(f"Error: {e}")
except Exception as e:
    print(f"Unexpected error: {e}")
else:
    print("No errors occurred")
finally:
    print("This always runs")

# Raising exceptions
def divide(a, b):
    if b == 0:
        raise ValueError("Cannot divide by zero")
    return a / b''',
          keyPoints: ['Specific exceptions first', 'else runs if no exception', 'finally always runs'],
        ),
        LanguageTopic(
          title: 'Popular Libraries',
          content: 'Essential libraries for various domains.',
          codeExample: '''# Data Science
import numpy as np
import pandas as pd

# Web Development
from flask import Flask
from django import urls

# Machine Learning
from sklearn.model_selection import train_test_split
import tensorflow as tf

# Automation
import requests
from selenium import webdriver''',
          keyPoints: ['NumPy for arrays', 'Pandas for data', 'Flask/Django for web', 'TensorFlow for ML'],
        ),
      ],
    ),

    // JavaScript
    ProgrammingLanguage(
      name: 'JavaScript',
      tagline: 'The Language of the Web',
      description: 'The most popular language for web development, running in browsers and servers.',
      icon: Icons.javascript,
      primaryColor: const Color(0xFFF7DF1E),
      secondaryColor: const Color(0xFF323330),
      difficulty: 'Beginner',
      yearCreated: 1995,
      creator: 'Brendan Eich',
      useCases: ['Web Frontend', 'Node.js Backend', 'Mobile Apps', 'Desktop Apps', 'Games'],
      topics: [
        LanguageTopic(
          title: 'Variables & Data Types',
          content: 'let, const, var for declarations. Primitive and reference types.',
          codeExample: '''// Modern variable declarations
let name = "JavaScript";  // can reassign
const PI = 3.14159;       // cannot reassign
var oldStyle = "legacy";  // function-scoped (avoid)

// Data types
const string = "Hello";
const number = 42;
const boolean = true;
const array = [1, 2, 3];
const object = { key: "value" };
const nullVal = null;
const undefinedVal = undefined;''',
          keyPoints: ['Use const by default', 'let for reassignment', 'Avoid var'],
        ),
        LanguageTopic(
          title: 'Arrow Functions',
          content: 'Modern function syntax with lexical this binding.',
          codeExample: '''// Traditional function
function add(a, b) {
    return a + b;
}

// Arrow function
const add = (a, b) => a + b;

// With body
const greet = (name) => {
    const message = \`Hello, \${name}!\`;
    return message;
};

// Array methods with arrows
const numbers = [1, 2, 3, 4, 5];
const doubled = numbers.map(n => n * 2);
const evens = numbers.filter(n => n % 2 === 0);''',
          keyPoints: ['Implicit return for single expression', 'Lexical this', 'Great for callbacks'],
        ),
        LanguageTopic(
          title: 'Async/Await & Promises',
          content: 'Handle asynchronous operations elegantly.',
          codeExample: '''// Promise
const fetchData = () => {
    return new Promise((resolve, reject) => {
        setTimeout(() => resolve("Data!"), 1000);
    });
};

// Async/Await
async function getData() {
    try {
        const result = await fetchData();
        console.log(result);
    } catch (error) {
        console.error(error);
    }
}

// Fetch API
const response = await fetch('https://api.example.com/data');
const data = await response.json();''',
          keyPoints: ['async functions return Promises', 'await pauses execution', 'try/catch for errors'],
        ),
        LanguageTopic(
          title: 'Destructuring & Spread',
          content: 'Extract values from arrays/objects and spread them.',
          codeExample: '''// Array destructuring
const [first, second, ...rest] = [1, 2, 3, 4, 5];

// Object destructuring
const { name, age, city = "Unknown" } = person;

// Spread operator
const combined = [...array1, ...array2];
const merged = { ...obj1, ...obj2 };

// Function parameters
const sum = (...numbers) => numbers.reduce((a, b) => a + b);''',
          keyPoints: ['Default values in destructuring', 'Rest operator collects', 'Spread expands'],
        ),
        LanguageTopic(
          title: 'DOM Manipulation',
          content: 'Interact with HTML elements on the page.',
          codeExample: '''// Selecting elements
const element = document.getElementById("myId");
const elements = document.querySelectorAll(".myClass");

// Modifying content
element.textContent = "New text";
element.innerHTML = "<strong>Bold</strong>";

// Event listeners
button.addEventListener("click", (event) => {
    console.log("Clicked!", event.target);
});

// Creating elements
const div = document.createElement("div");
div.classList.add("card");
parent.appendChild(div);''',
          keyPoints: ['querySelector for CSS selectors', 'addEventListener for events', 'classList for classes'],
        ),
        LanguageTopic(
          title: 'ES6+ Features',
          content: 'Modern JavaScript features from ES6 and beyond.',
          codeExample: '''// Template literals
const message = \`Hello, \${name}!\`;

// Optional chaining
const city = user?.address?.city ?? "Unknown";

// Nullish coalescing
const value = input ?? "default";

// Object shorthand
const x = 10, y = 20;
const point = { x, y };  // { x: 10, y: 20 }

// Dynamic property names
const key = "name";
const obj = { [key]: "value" };''',
          keyPoints: ['?. prevents errors on null/undefined', '?? only for null/undefined', 'Shorthand saves typing'],
        ),
      ],
    ),

    // C Language
    ProgrammingLanguage(
      name: 'C',
      tagline: 'The Foundation of Computing',
      description: 'The mother of all languages. Low-level control with high-level syntax.',
      icon: Icons.code,
      primaryColor: const Color(0xFF5C6BC0),
      secondaryColor: const Color(0xFF1A237E),
      difficulty: 'Intermediate',
      yearCreated: 1972,
      creator: 'Dennis Ritchie',
      useCases: ['Operating Systems', 'Embedded Systems', 'Compilers', 'Game Engines', 'Drivers'],
      topics: [
        LanguageTopic(
          title: 'Basic Syntax & Structure',
          content: 'Every C program needs main(). Statements end with semicolons.',
          codeExample: '''#include <stdio.h>

int main() {
    // Variable declarations
    int age = 25;
    float pi = 3.14159;
    char grade = 'A';
    
    // Output
    printf("Age: %d\\n", age);
    printf("Pi: %.2f\\n", pi);
    printf("Grade: %c\\n", grade);
    
    return 0;
}''',
          keyPoints: ['#include for headers', 'main() is entry point', 'printf for output'],
        ),
        LanguageTopic(
          title: 'Pointers',
          content: 'Variables that store memory addresses. The core of C.',
          codeExample: '''int x = 10;
int *ptr = &x;  // ptr holds address of x

printf("Value: %d\\n", x);      // 10
printf("Address: %p\\n", &x);   // 0x7fff...
printf("Pointer: %p\\n", ptr);  // same address
printf("Dereferenced: %d\\n", *ptr); // 10

// Pointer arithmetic
int arr[] = {10, 20, 30};
int *p = arr;
printf("%d\\n", *(p + 1));  // 20''',
          keyPoints: ['& gets address', '* dereferences', 'Array name is pointer to first element'],
        ),
        LanguageTopic(
          title: 'Memory Management',
          content: 'Manual memory allocation with malloc, calloc, realloc, free.',
          codeExample: '''#include <stdlib.h>

// Allocate memory for 5 integers
int *arr = (int*)malloc(5 * sizeof(int));

// Check if allocation succeeded
if (arr == NULL) {
    printf("Memory allocation failed!\\n");
    return 1;
}

// Use the memory
for (int i = 0; i < 5; i++) {
    arr[i] = i * 10;
}

// Free memory when done
free(arr);
arr = NULL;  // Avoid dangling pointer''',
          keyPoints: ['malloc allocates', 'Always check for NULL', 'free releases memory'],
        ),
        LanguageTopic(
          title: 'Structures',
          content: 'Group related data together under one name.',
          codeExample: '''struct Student {
    char name[50];
    int age;
    float gpa;
};

// Using typedef
typedef struct {
    int x;
    int y;
} Point;

int main() {
    struct Student s1 = {"Alice", 20, 3.8};
    Point p1 = {10, 20};
    
    printf("Name: %s, GPA: %.1f\\n", s1.name, s1.gpa);
    printf("Point: (%d, %d)\\n", p1.x, p1.y);
    
    return 0;
}''',
          keyPoints: ['struct groups data', 'typedef creates alias', 'Access with dot operator'],
        ),
        LanguageTopic(
          title: 'File I/O',
          content: 'Read and write files using FILE pointers.',
          codeExample: '''#include <stdio.h>

// Writing to file
FILE *fp = fopen("data.txt", "w");
if (fp != NULL) {
    fprintf(fp, "Hello, File!\\n");
    fclose(fp);
}

// Reading from file
FILE *fp = fopen("data.txt", "r");
char buffer[100];
while (fgets(buffer, sizeof(buffer), fp)) {
    printf("%s", buffer);
}
fclose(fp);''',
          keyPoints: ['fopen opens file', 'Check for NULL', 'fclose is mandatory'],
        ),
      ],
    ),

    // C++
    ProgrammingLanguage(
      name: 'C++',
      tagline: 'Performance Meets Power',
      description: 'C with classes. High performance with object-oriented features.',
      icon: Icons.add_box,
      primaryColor: const Color(0xFF00599C),
      secondaryColor: const Color(0xFF004482),
      difficulty: 'Advanced',
      yearCreated: 1985,
      creator: 'Bjarne Stroustrup',
      useCases: ['Game Development', 'Systems Programming', 'Embedded', 'Finance', 'Graphics'],
      topics: [
        LanguageTopic(
          title: 'Classes & Objects',
          content: 'Object-oriented programming with classes, constructors, and destructors.',
          codeExample: '''class Rectangle {
private:
    int width, height;
    
public:
    // Constructor
    Rectangle(int w, int h) : width(w), height(h) {}
    
    // Destructor
    ~Rectangle() { cout << "Destroyed" << endl; }
    
    // Member function
    int area() const { return width * height; }
    
    // Getter/Setter
    int getWidth() const { return width; }
    void setWidth(int w) { width = w; }
};

Rectangle rect(10, 5);
cout << "Area: " << rect.area() << endl;''',
          keyPoints: ['Private by default', 'Constructor initializer list', 'const for read-only methods'],
        ),
        LanguageTopic(
          title: 'STL Containers',
          content: 'Standard Template Library containers for data storage.',
          codeExample: '''#include <vector>
#include <map>
#include <set>
#include <string>

// Vector
vector<int> nums = {1, 2, 3, 4, 5};
nums.push_back(6);

// Map
map<string, int> ages;
ages["Alice"] = 25;
ages["Bob"] = 30;

// Set
set<int> unique_nums = {3, 1, 4, 1, 5};  // {1, 3, 4, 5}

// Iteration
for (const auto& [name, age] : ages) {
    cout << name << ": " << age << endl;
}''',
          keyPoints: ['vector for dynamic arrays', 'map for key-value', 'set for unique values'],
        ),
        LanguageTopic(
          title: 'Smart Pointers',
          content: 'Automatic memory management with RAII.',
          codeExample: '''#include <memory>

// Unique pointer (exclusive ownership)
unique_ptr<int> ptr1 = make_unique<int>(42);
cout << *ptr1 << endl;

// Shared pointer (reference counting)
shared_ptr<int> ptr2 = make_shared<int>(100);
shared_ptr<int> ptr3 = ptr2;  // count = 2

// Weak pointer (no ownership)
weak_ptr<int> weak = ptr2;

// No need to delete - automatic cleanup!''',
          keyPoints: ['unique_ptr for single owner', 'shared_ptr for shared ownership', 'RAII manages memory'],
        ),
        LanguageTopic(
          title: 'Templates',
          content: 'Generic programming with templates.',
          codeExample: '''// Function template
template<typename T>
T max(T a, T b) {
    return (a > b) ? a : b;
}

// Class template
template<typename T>
class Stack {
private:
    vector<T> elements;
public:
    void push(T element) { elements.push_back(element); }
    T pop() {
        T top = elements.back();
        elements.pop_back();
        return top;
    }
};

Stack<int> intStack;
Stack<string> strStack;''',
          keyPoints: ['template<typename T>', 'Works with any type', 'Compile-time polymorphism'],
        ),
        LanguageTopic(
          title: 'Lambda Expressions',
          content: 'Anonymous functions introduced in C++11.',
          codeExample: '''#include <algorithm>
#include <vector>

vector<int> nums = {5, 2, 8, 1, 9};

// Sort with lambda
sort(nums.begin(), nums.end(), [](int a, int b) {
    return a < b;
});

// Capture variables
int factor = 2;
auto multiply = [factor](int x) { return x * factor; };

// Capture by reference
int sum = 0;
for_each(nums.begin(), nums.end(), [&sum](int x) {
    sum += x;
});''',
          keyPoints: ['[] captures variables', '() parameters', '-> return type optional'],
        ),
      ],
    ),

    // Java
    ProgrammingLanguage(
      name: 'Java',
      tagline: 'Write Once, Run Anywhere',
      description: 'Enterprise-grade, platform-independent language with a vast ecosystem.',
      icon: Icons.coffee,
      primaryColor: const Color(0xFFED8B00),
      secondaryColor: const Color(0xFF5382A1),
      difficulty: 'Intermediate',
      yearCreated: 1995,
      creator: 'James Gosling (Sun)',
      useCases: ['Enterprise Apps', 'Android', 'Web Services', 'Big Data', 'Cloud'],
      topics: [
        LanguageTopic(
          title: 'Classes & Objects',
          content: 'Everything in Java is inside a class. Objects are instances of classes.',
          codeExample: '''public class Person {
    // Fields
    private String name;
    private int age;
    
    // Constructor
    public Person(String name, int age) {
        this.name = name;
        this.age = age;
    }
    
    // Getter
    public String getName() { return name; }
    
    // Method
    public void greet() {
        System.out.println("Hello, I'm " + name);
    }
}

Person person = new Person("Alice", 25);
person.greet();''',
          keyPoints: ['public class matches filename', 'new creates object', 'this refers to current object'],
        ),
        LanguageTopic(
          title: 'Inheritance & Interfaces',
          content: 'Extend classes and implement interfaces for polymorphism.',
          codeExample: '''// Interface
interface Drawable {
    void draw();
}

// Abstract class
abstract class Shape implements Drawable {
    abstract double area();
}

// Concrete class
class Circle extends Shape {
    private double radius;
    
    public Circle(double r) { this.radius = r; }
    
    @Override
    public double area() { return Math.PI * radius * radius; }
    
    @Override
    public void draw() { System.out.println("Drawing circle"); }
}''',
          keyPoints: ['extends for class', 'implements for interface', '@Override annotation'],
        ),
        LanguageTopic(
          title: 'Collections Framework',
          content: 'Lists, Sets, Maps, and Queues for data storage.',
          codeExample: '''import java.util.*;

// List
List<String> names = new ArrayList<>();
names.add("Alice");
names.add("Bob");

// Set
Set<Integer> unique = new HashSet<>(Arrays.asList(1, 2, 2, 3));

// Map
Map<String, Integer> ages = new HashMap<>();
ages.put("Alice", 25);
ages.get("Alice");  // 25

// Stream API
names.stream()
     .filter(n -> n.startsWith("A"))
     .forEach(System.out::println);''',
          keyPoints: ['ArrayList for list', 'HashMap for map', 'Streams for functional style'],
        ),
        LanguageTopic(
          title: 'Exception Handling',
          content: 'Handle errors with try-catch-finally blocks.',
          codeExample: '''public void readFile(String path) throws IOException {
    try {
        BufferedReader reader = new BufferedReader(
            new FileReader(path)
        );
        String line = reader.readLine();
        System.out.println(line);
    } catch (FileNotFoundException e) {
        System.err.println("File not found: " + path);
    } catch (IOException e) {
        System.err.println("Error reading file");
        throw e;  // Re-throw
    } finally {
        System.out.println("Cleanup complete");
    }
}''',
          keyPoints: ['Checked vs unchecked exceptions', 'throws in signature', 'finally always runs'],
        ),
        LanguageTopic(
          title: 'Multithreading',
          content: 'Concurrent programming with threads.',
          codeExample: '''// Runnable interface
Runnable task = () -> {
    System.out.println("Running in: " + 
        Thread.currentThread().getName());
};

Thread thread = new Thread(task);
thread.start();

// ExecutorService
ExecutorService executor = Executors.newFixedThreadPool(4);
executor.submit(task);
executor.shutdown();

// Synchronized method
public synchronized void increment() {
    count++;
}''',
          keyPoints: ['Runnable for task', 'ExecutorService for pool', 'synchronized for thread safety'],
        ),
      ],
    ),

    // Kotlin
    ProgrammingLanguage(
      name: 'Kotlin',
      tagline: 'Modern Android Development',
      description: 'Concise, safe, and fully interoperable with Java. Official Android language.',
      icon: Icons.android,
      primaryColor: const Color(0xFF7F52FF),
      secondaryColor: const Color(0xFFE24462),
      difficulty: 'Intermediate',
      yearCreated: 2011,
      creator: 'JetBrains',
      useCases: ['Android Apps', 'Server-side', 'Multiplatform', 'Web', 'Data Science'],
      topics: [
        LanguageTopic(
          title: 'Variables & Null Safety',
          content: 'val for immutable, var for mutable. Null safety built-in.',
          codeExample: '''// Immutable vs Mutable
val name: String = "Kotlin"  // cannot reassign
var age: Int = 10            // can reassign

// Null safety
var nullable: String? = null
var nonNull: String = "Hello"

// Safe calls
val length = nullable?.length

// Elvis operator
val len = nullable?.length ?: 0

// Not-null assertion (dangerous!)
val unsafeLen = nullable!!.length''',
          keyPoints: ['val = final', '? allows null', '?: is Elvis operator'],
        ),
        LanguageTopic(
          title: 'Data Classes',
          content: 'Automatic equals, hashCode, toString, copy.',
          codeExample: '''data class User(
    val id: Int,
    val name: String,
    val email: String
)

val user1 = User(1, "Alice", "alice@email.com")
val user2 = user1.copy(name = "Bob")

println(user1)  // User(id=1, name=Alice, ...)
println(user1 == user2)  // false

// Destructuring
val (id, name, email) = user1''',
          keyPoints: ['data class auto-generates methods', 'copy() for modification', 'Destructuring built-in'],
        ),
        LanguageTopic(
          title: 'Coroutines',
          content: 'Lightweight threads for asynchronous programming.',
          codeExample: '''import kotlinx.coroutines.*

// Launch coroutine
GlobalScope.launch {
    delay(1000)
    println("World!")
}
println("Hello,")

// Suspend function
suspend fun fetchData(): String {
    delay(1000)  // Non-blocking
    return "Data loaded"
}

// Async/Await
val deferred = async { fetchData() }
val result = deferred.await()''',
          keyPoints: ['launch for fire-and-forget', 'async for results', 'suspend marks coroutine functions'],
        ),
        LanguageTopic(
          title: 'Extension Functions',
          content: 'Add methods to existing classes without inheritance.',
          codeExample: '''// Extension function
fun String.addExclamation(): String {
    return this + "!"
}

println("Hello".addExclamation())  // Hello!

// Extension property
val String.wordCount: Int
    get() = this.split(" ").size

println("Hello World".wordCount)  // 2

// Scope functions
val result = StringBuilder().apply {
    append("Hello, ")
    append("Kotlin!")
}.toString()''',
          keyPoints: ['Extend any class', 'apply/let/run/with/also', 'Receiver is this'],
        ),
      ],
    ),

    // Go
    ProgrammingLanguage(
      name: 'Go',
      tagline: 'Simple. Reliable. Efficient.',
      description: 'Google\'s language for scalable, concurrent systems. Fast compilation.',
      icon: Icons.directions_run,
      primaryColor: const Color(0xFF00ADD8),
      secondaryColor: const Color(0xFF5DC9E2),
      difficulty: 'Intermediate',
      yearCreated: 2009,
      creator: 'Google (Pike, Thompson, Griesemer)',
      useCases: ['Cloud Services', 'Microservices', 'DevOps Tools', 'Networking', 'CLI Tools'],
      topics: [
        LanguageTopic(
          title: 'Variables & Types',
          content: 'Static typing with type inference. Simple syntax.',
          codeExample: '''package main

import "fmt"

func main() {
    // Explicit type
    var name string = "Go"
    
    // Type inference
    age := 14
    
    // Multiple variables
    var x, y int = 10, 20
    
    // Constants
    const PI = 3.14159
    
    fmt.Println(name, age, PI)
}''',
          keyPoints: [':= for short declaration', 'var for explicit', 'const for constants'],
        ),
        LanguageTopic(
          title: 'Goroutines & Channels',
          content: 'Lightweight concurrency primitives.',
          codeExample: '''func worker(id int, jobs <-chan int, results chan<- int) {
    for j := range jobs {
        fmt.Println("Worker", id, "processing job", j)
        results <- j * 2
    }
}

func main() {
    jobs := make(chan int, 100)
    results := make(chan int, 100)
    
    // Start 3 workers
    for w := 1; w <= 3; w++ {
        go worker(w, jobs, results)
    }
    
    // Send jobs
    for j := 1; j <= 5; j++ {
        jobs <- j
    }
    close(jobs)
}''',
          keyPoints: ['go keyword for goroutine', 'Channels for communication', 'range for receiving'],
        ),
        LanguageTopic(
          title: 'Structs & Interfaces',
          content: 'Composition over inheritance. Implicit interfaces.',
          codeExample: '''type Shape interface {
    Area() float64
}

type Rectangle struct {
    Width, Height float64
}

func (r Rectangle) Area() float64 {
    return r.Width * r.Height
}

type Circle struct {
    Radius float64
}

func (c Circle) Area() float64 {
    return 3.14159 * c.Radius * c.Radius
}

func printArea(s Shape) {
    fmt.Println("Area:", s.Area())
}''',
          keyPoints: ['No explicit implements', 'Methods have receivers', 'Composition via embedding'],
        ),
        LanguageTopic(
          title: 'Error Handling',
          content: 'Explicit error handling with multiple returns.',
          codeExample: '''import (
    "errors"
    "fmt"
)

func divide(a, b float64) (float64, error) {
    if b == 0 {
        return 0, errors.New("division by zero")
    }
    return a / b, nil
}

func main() {
    result, err := divide(10, 0)
    if err != nil {
        fmt.Println("Error:", err)
        return
    }
    fmt.Println("Result:", result)
}''',
          keyPoints: ['Multiple return values', 'nil for no error', 'Check err != nil'],
        ),
      ],
    ),

    // Rust
    ProgrammingLanguage(
      name: 'Rust',
      tagline: 'Safe, Fast, Concurrent',
      description: 'Memory safety without garbage collection. Zero-cost abstractions.',
      icon: Icons.security,
      primaryColor: const Color(0xFFDEA584),
      secondaryColor: const Color(0xFF000000),
      difficulty: 'Advanced',
      yearCreated: 2010,
      creator: 'Mozilla (Graydon Hoare)',
      useCases: ['Systems Programming', 'WebAssembly', 'CLI Tools', 'Embedded', 'Blockchain'],
      topics: [
        LanguageTopic(
          title: 'Ownership',
          content: 'Rust\'s unique memory management system.',
          codeExample: '''fn main() {
    let s1 = String::from("hello");  // s1 owns the String
    let s2 = s1;  // Ownership moves to s2
    // println!("{}", s1);  // ERROR! s1 is invalid
    println!("{}", s2);  // OK
    
    // Clone for deep copy
    let s3 = s2.clone();
    println!("{} {}", s2, s3);  // Both valid
}''',
          keyPoints: ['Each value has one owner', 'Move semantics by default', 'Clone for deep copy'],
        ),
        LanguageTopic(
          title: 'Borrowing & References',
          content: 'Borrow values without taking ownership.',
          codeExample: '''fn calculate_length(s: &String) -> usize {
    s.len()  // s is borrowed, not owned
}

fn main() {
    let s = String::from("hello");
    let len = calculate_length(&s);  // Borrow s
    println!("{} has length {}", s, len);  // s still valid
    
    // Mutable borrow (only one at a time)
    let mut s = String::from("hello");
    change(&mut s);
}

fn change(s: &mut String) {
    s.push_str(", world");
}''',
          keyPoints: ['& immutable borrow', '&mut mutable borrow', 'Only one mut borrow'],
        ),
        LanguageTopic(
          title: 'Pattern Matching',
          content: 'Powerful match expressions for control flow.',
          codeExample: '''enum Coin {
    Penny,
    Nickel,
    Dime,
    Quarter,
}

fn value_in_cents(coin: Coin) -> u8 {
    match coin {
        Coin::Penny => 1,
        Coin::Nickel => 5,
        Coin::Dime => 10,
        Coin::Quarter => 25,
    }
}

// Option handling
let x: Option<i32> = Some(5);
match x {
    Some(n) => println!("Got {}", n),
    None => println!("Got nothing"),
}''',
          keyPoints: ['match is exhaustive', 'Option for nullable', 'Destructure in patterns'],
        ),
        LanguageTopic(
          title: 'Traits',
          content: 'Define shared behavior across types.',
          codeExample: '''trait Summary {
    fn summarize(&self) -> String;
    
    // Default implementation
    fn author(&self) -> String {
        String::from("Unknown")
    }
}

struct Article {
    title: String,
    content: String,
}

impl Summary for Article {
    fn summarize(&self) -> String {
        format!("{}: {}", self.title, &self.content[..50])
    }
}

fn notify(item: &impl Summary) {
    println!("News: {}", item.summarize());
}''',
          keyPoints: ['trait defines behavior', 'impl Trait for Type', 'Default methods allowed'],
        ),
      ],
    ),

    // Dart
    ProgrammingLanguage(
      name: 'Dart',
      tagline: 'Client-Optimized Language',
      description: 'Designed for building fast apps on any platform. Powers Flutter.',
      icon: Icons.flutter_dash,
      primaryColor: const Color(0xFF0175C2),
      secondaryColor: const Color(0xFF02569B),
      difficulty: 'Beginner',
      yearCreated: 2011,
      creator: 'Google (Lars Bak, Kasper Lund)',
      useCases: ['Flutter Apps', 'Web', 'Server-side', 'IoT', 'Scripting'],
      topics: [
        LanguageTopic(
          title: 'Variables & Types',
          content: 'Sound null safety. Type inference with var.',
          codeExample: '''void main() {
  // Type inference
  var name = 'Dart';
  
  // Explicit types
  String greeting = 'Hello';
  int age = 12;
  double pi = 3.14;
  bool isAwesome = true;
  
  // Final and const
  final timestamp = DateTime.now();  // Runtime constant
  const pi2 = 3.14159;  // Compile-time constant
  
  // Null safety
  String? nullable;
  String nonNull = 'Hello';
}''',
          keyPoints: ['var for inference', 'final for runtime const', 'const for compile-time'],
        ),
        LanguageTopic(
          title: 'Classes & Constructors',
          content: 'Object-oriented with named constructors and factory.',
          codeExample: '''class Person {
  final String name;
  int age;
  
  // Primary constructor
  Person(this.name, this.age);
  
  // Named constructor
  Person.guest() : name = 'Guest', age = 0;
  
  // Factory constructor
  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(json['name'], json['age']);
  }
  
  @override
  String toString() => 'Person(name: \$name, age: \$age)';
}

var person = Person('Alice', 25);
var guest = Person.guest();''',
          keyPoints: ['this.x shorthand', 'Named constructors', 'Factory for logic'],
        ),
        LanguageTopic(
          title: 'Async/Await',
          content: 'Handle asynchronous operations with Futures.',
          codeExample: '''Future<String> fetchData() async {
  await Future.delayed(Duration(seconds: 1));
  return 'Data loaded!';
}

Stream<int> countStream(int max) async* {
  for (int i = 1; i <= max; i++) {
    await Future.delayed(Duration(milliseconds: 500));
    yield i;  // Emit value
  }
}

void main() async {
  // Future
  var data = await fetchData();
  print(data);
  
  // Stream
  await for (var count in countStream(5)) {
    print(count);
  }
}''',
          keyPoints: ['async/await for Futures', 'async* for Streams', 'yield emits values'],
        ),
        LanguageTopic(
          title: 'Collections',
          content: 'Lists, Sets, Maps with powerful operators.',
          codeExample: '''void main() {
  // List
  var list = [1, 2, 3];
  list.add(4);
  
  // Set
  var set = {1, 2, 3};
  
  // Map
  var map = {'name': 'Dart', 'version': 3};
  
  // Spread operator
  var combined = [...list, 5, 6];
  
  // Collection if/for
  var items = [
    'first',
    if (true) 'second',
    for (var i in [1, 2, 3]) 'item\$i',
  ];
  
  // Cascade notation
  var buffer = StringBuffer()
    ..write('Hello, ')
    ..write('Dart!')
    ..toString();
}''',
          keyPoints: ['Spread with ...', 'Collection if/for', 'Cascade with ..'],
        ),
      ],
    ),

    // TypeScript
    ProgrammingLanguage(
      name: 'TypeScript',
      tagline: 'JavaScript with Types',
      description: 'Strongly typed JavaScript superset. Catches errors at compile time.',
      icon: Icons.text_snippet,
      primaryColor: const Color(0xFF3178C6),
      secondaryColor: const Color(0xFF235A97),
      difficulty: 'Intermediate',
      yearCreated: 2012,
      creator: 'Microsoft (Anders Hejlsberg)',
      useCases: ['Web Apps', 'Node.js', 'React/Angular/Vue', 'APIs', 'Libraries'],
      topics: [
        LanguageTopic(
          title: 'Basic Types',
          content: 'Type annotations for variables and function parameters.',
          codeExample: '''// Primitive types
let name: string = "TypeScript";
let age: number = 11;
let isTyped: boolean = true;

// Arrays
let numbers: number[] = [1, 2, 3];
let names: Array<string> = ["a", "b"];

// Tuple
let person: [string, number] = ["Alice", 25];

// Enum
enum Color { Red, Green, Blue }
let c: Color = Color.Green;

// Any and Unknown
let flexible: any = 4;
let safer: unknown = "hello";''',
          keyPoints: ['Type after colon', 'Array<T> or T[]', 'unknown safer than any'],
        ),
        LanguageTopic(
          title: 'Interfaces & Types',
          content: 'Define object shapes and type aliases.',
          codeExample: '''// Interface
interface User {
  id: number;
  name: string;
  email?: string;  // Optional
  readonly createdAt: Date;  // Immutable
}

// Type alias
type Point = {
  x: number;
  y: number;
};

// Union type
type ID = string | number;

// Intersection type
type Employee = User & {
  department: string;
};

// Extending interface
interface Admin extends User {
  permissions: string[];
}''',
          keyPoints: ['? for optional', 'readonly for immutable', '| for union, & for intersection'],
        ),
        LanguageTopic(
          title: 'Generics',
          content: 'Write reusable, type-safe code.',
          codeExample: '''// Generic function
function identity<T>(arg: T): T {
  return arg;
}

let output = identity<string>("hello");

// Generic interface
interface Box<T> {
  value: T;
}

// Generic class
class Stack<T> {
  private items: T[] = [];
  
  push(item: T): void {
    this.items.push(item);
  }
  
  pop(): T | undefined {
    return this.items.pop();
  }
}

// Generic constraints
function getLength<T extends { length: number }>(arg: T): number {
  return arg.length;
}''',
          keyPoints: ['<T> declares type parameter', 'extends for constraints', 'Inferred when possible'],
        ),
        LanguageTopic(
          title: 'Utility Types',
          content: 'Built-in types for common transformations.',
          codeExample: '''interface Todo {
  title: string;
  description: string;
  completed: boolean;
}

// Partial - all optional
type PartialTodo = Partial<Todo>;

// Required - all required
type RequiredTodo = Required<Todo>;

// Pick - subset of properties
type TodoPreview = Pick<Todo, "title" | "completed">;

// Omit - exclude properties
type TodoInfo = Omit<Todo, "completed">;

// Record - key-value mapping
type PageMap = Record<string, { title: string }>;

// ReturnType - infer return type
type MyFunc = () => { name: string };
type MyReturn = ReturnType<MyFunc>;''',
          keyPoints: ['Partial makes optional', 'Pick selects props', 'Omit removes props'],
        ),
      ],
    ),

    // SQL
    ProgrammingLanguage(
      name: 'SQL',
      tagline: 'The Language of Data',
      description: 'Query and manipulate relational databases. Essential for backend development.',
      icon: Icons.storage,
      primaryColor: const Color(0xFFCC2927),
      secondaryColor: const Color(0xFF4479A1),
      difficulty: 'Beginner',
      yearCreated: 1974,
      creator: 'IBM (Chamberlin & Boyce)',
      useCases: ['Databases', 'Data Analysis', 'Reporting', 'ETL', 'Data Warehousing'],
      topics: [
        LanguageTopic(
          title: 'Basic Queries',
          content: 'SELECT, FROM, WHERE for data retrieval.',
          codeExample: '''-- Select all columns
SELECT * FROM users;

-- Select specific columns
SELECT name, email FROM users;

-- Filter with WHERE
SELECT * FROM users WHERE age > 18;

-- Multiple conditions
SELECT * FROM products
WHERE price < 100 AND category = 'Electronics';

-- Pattern matching
SELECT * FROM users WHERE name LIKE 'A%';

-- Ordering
SELECT * FROM users ORDER BY created_at DESC;

-- Limiting results
SELECT * FROM users LIMIT 10 OFFSET 20;''',
          keyPoints: ['SELECT columns FROM table', 'WHERE for filtering', 'LIKE for patterns'],
        ),
        LanguageTopic(
          title: 'Joins',
          content: 'Combine data from multiple tables.',
          codeExample: '''-- INNER JOIN (matching rows only)
SELECT users.name, orders.total
FROM users
INNER JOIN orders ON users.id = orders.user_id;

-- LEFT JOIN (all from left + matching)
SELECT u.name, COALESCE(COUNT(o.id), 0) as order_count
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
GROUP BY u.id;

-- Multiple joins
SELECT o.id, u.name, p.title
FROM orders o
JOIN users u ON o.user_id = u.id
JOIN products p ON o.product_id = p.id;''',
          keyPoints: ['INNER for intersection', 'LEFT keeps all left rows', 'Use aliases for clarity'],
        ),
        LanguageTopic(
          title: 'Aggregations',
          content: 'GROUP BY, COUNT, SUM, AVG for data analysis.',
          codeExample: '''-- Count rows
SELECT COUNT(*) FROM users;

-- Aggregate functions
SELECT 
    category,
    COUNT(*) as count,
    SUM(price) as total,
    AVG(price) as average,
    MAX(price) as max_price,
    MIN(price) as min_price
FROM products
GROUP BY category;

-- Filter groups with HAVING
SELECT category, AVG(price) as avg_price
FROM products
GROUP BY category
HAVING AVG(price) > 50;''',
          keyPoints: ['GROUP BY for aggregation', 'HAVING filters groups', 'WHERE filters rows'],
        ),
        LanguageTopic(
          title: 'Subqueries & CTEs',
          content: 'Nested queries and Common Table Expressions.',
          codeExample: '''-- Subquery in WHERE
SELECT * FROM users
WHERE id IN (
    SELECT user_id FROM orders
    WHERE total > 1000
);

-- Subquery in FROM
SELECT avg_price FROM (
    SELECT AVG(price) as avg_price
    FROM products
) as subquery;

-- Common Table Expression (CTE)
WITH high_spenders AS (
    SELECT user_id, SUM(total) as total_spent
    FROM orders
    GROUP BY user_id
    HAVING SUM(total) > 5000
)
SELECT u.name, hs.total_spent
FROM users u
JOIN high_spenders hs ON u.id = hs.user_id;''',
          keyPoints: ['IN for subquery results', 'CTEs improve readability', 'WITH comes before SELECT'],
        ),
      ],
    ),

    // Swift
    ProgrammingLanguage(
      name: 'Swift',
      tagline: 'Safe, Fast, Expressive',
      description: 'Apple\'s modern language for iOS, macOS, and beyond.',
      icon: Icons.apple,
      primaryColor: const Color(0xFFFA7343),
      secondaryColor: const Color(0xFFF05138),
      difficulty: 'Intermediate',
      yearCreated: 2014,
      creator: 'Apple (Chris Lattner)',
      useCases: ['iOS Apps', 'macOS Apps', 'watchOS', 'tvOS', 'Server-side'],
      topics: [
        LanguageTopic(
          title: 'Optionals',
          content: 'Safe handling of nil values.',
          codeExample: '''// Optional declaration
var name: String? = nil
name = "Swift"

// Optional binding
if let unwrapped = name {
    print("Name is \\(unwrapped)")
}

// Guard statement
func greet(_ name: String?) {
    guard let name = name else {
        print("No name provided")
        return
    }
    print("Hello, \\(name)")
}

// Nil coalescing
let displayName = name ?? "Anonymous"

// Optional chaining
let length = name?.count''',
          keyPoints: ['? declares optional', 'if let unwraps', '?? provides default'],
        ),
        LanguageTopic(
          title: 'Structs & Classes',
          content: 'Value types vs reference types.',
          codeExample: '''// Struct (value type, copied)
struct Point {
    var x: Double
    var y: Double
    
    mutating func moveBy(dx: Double, dy: Double) {
        x += dx
        y += dy
    }
}

// Class (reference type, shared)
class Person {
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
    deinit {
        print("\\(name) is being deallocated")
    }
}

var p1 = Point(x: 0, y: 0)
var p2 = p1  // Copy
p2.x = 10
print(p1.x)  // Still 0''',
          keyPoints: ['Structs are copied', 'Classes are referenced', 'mutating for struct methods'],
        ),
        LanguageTopic(
          title: 'Protocols & Extensions',
          content: 'Define blueprints and extend existing types.',
          codeExample: '''// Protocol
protocol Describable {
    var description: String { get }
    func describe()
}

// Protocol extension (default implementation)
extension Describable {
    func describe() {
        print(description)
    }
}

// Extend existing type
extension Int {
    var squared: Int {
        return self * self
    }
    
    func times(_ action: () -> Void) {
        for _ in 0..<self {
            action()
        }
    }
}

5.times { print("Hi!") }
print(4.squared)  // 16''',
          keyPoints: ['protocol for blueprint', 'extension adds functionality', 'Default implementations'],
        ),
        LanguageTopic(
          title: 'Closures',
          content: 'Self-contained blocks of functionality.',
          codeExample: '''// Closure syntax
let add: (Int, Int) -> Int = { (a, b) in
    return a + b
}

// Trailing closure
let numbers = [1, 2, 3, 4, 5]
let doubled = numbers.map { \$0 * 2 }
let evens = numbers.filter { \$0 % 2 == 0 }
let sum = numbers.reduce(0) { \$0 + \$1 }

// Capturing values
func makeCounter() -> () -> Int {
    var count = 0
    return {
        count += 1
        return count
    }
}

let counter = makeCounter()
print(counter())  // 1
print(counter())  // 2''',
          keyPoints: ['\$0, \$1 shorthand args', 'Trailing closure syntax', 'Closures capture values'],
        ),
      ],
    ),

    // Go (Golang)
    ProgrammingLanguage(
      name: 'Go',
      tagline: 'Simple, Fast, Efficient',
      description: 'Googles language for cloud computing, microservices, and high-performance systems.',
      icon: Icons.speed,
      primaryColor: const Color(0xFF00ADD8),
      secondaryColor: const Color(0xFF00A29C),
      difficulty: 'Intermediate',
      yearCreated: 2009,
      creator: 'Google (Rob Pike)',
      useCases: ['Cloud/DevOps', 'Microservices', 'CLI Tools', 'Networking', 'Kubernetes'],
      topics: [
        LanguageTopic(
          title: 'Variables & Types',
          content: 'Statically typed with type inference. No semicolons needed.',
          codeExample: '''package main
import "fmt"

func main() {
    // Type inference with :=
    name := "Gopher"
    age := 10
    pi := 3.14159
    
    // Explicit type
    var count int = 100
    var message string = "Hello"
    
    // Multiple assignment
    x, y := 10, 20
    
    // Constants
    const MaxSize = 1000
    
    fmt.Printf("%s is %d years old\\n", name, age)
}''',
          keyPoints: [':= for short declaration', 'var for explicit type', 'const for constants'],
          shortcuts: ['go run main.go - Run file', 'go build - Compile', 'go fmt - Format code', 'gofmt -w . - Format all'],
        ),
        LanguageTopic(
          title: 'Functions & Methods',
          content: 'Functions can return multiple values. Methods attach to types.',
          codeExample: '''// Multiple return values
func divide(a, b int) (int, error) {
    if b == 0 {
        return 0, errors.New("division by zero")
    }
    return a / b, nil
}

// Named return values
func minMax(nums []int) (min, max int) {
    min, max = nums[0], nums[0]
    for _, n := range nums {
        if n < min { min = n }
        if n > max { max = n }
    }
    return  // naked return
}

// Method on type
type Rectangle struct {
    Width, Height float64
}

func (r Rectangle) Area() float64 {
    return r.Width * r.Height
}''',
          keyPoints: ['Multiple returns', 'Named returns', 'Methods with receivers'],
          shortcuts: ['_ ignores value', 'range for iteration', 'defer for cleanup'],
        ),
        LanguageTopic(
          title: 'Goroutines & Channels',
          content: 'Lightweight threads and communication primitives.',
          codeExample: '''// Goroutine - lightweight thread
go func() {
    fmt.Println("Running concurrently!")
}()

// Channel - communication
ch := make(chan int)

go func() {
    ch <- 42  // Send to channel
}()

value := <-ch  // Receive from channel
fmt.Println(value)  // 42

// Buffered channel
buffered := make(chan int, 3)

// Select for multiple channels
select {
case msg := <-ch1:
    fmt.Println("From ch1:", msg)
case msg := <-ch2:
    fmt.Println("From ch2:", msg)
default:
    fmt.Println("No message")
}''',
          keyPoints: ['go keyword starts goroutine', '<- sends/receives', 'select for multiplexing'],
          shortcuts: ['make(chan T) - unbuffered', 'make(chan T, n) - buffered', 'close(ch) - close channel'],
        ),
        LanguageTopic(
          title: 'Structs & Interfaces',
          content: 'Composition over inheritance. Implicit interface satisfaction.',
          codeExample: '''// Struct
type Person struct {
    Name string
    Age  int
}

// Embedding (composition)
type Employee struct {
    Person  // embedded
    Salary float64
}

// Interface - implicit satisfaction
type Speaker interface {
    Speak() string
}

type Dog struct{ Name string }

func (d Dog) Speak() string {
    return d.Name + " says Woof!"
}

// Dog automatically implements Speaker
var s Speaker = Dog{Name: "Buddy"}
fmt.Println(s.Speak())''',
          keyPoints: ['Embedding for composition', 'Implicit interfaces', 'No extends/implements keyword'],
          shortcuts: ['&T{} - pointer to struct', 'type T = U - type alias', 'type T U - new type'],
        ),
        LanguageTopic(
          title: 'Error Handling',
          content: 'Explicit error handling with error type.',
          codeExample: '''import (
    "errors"
    "fmt"
)

// Custom error
var ErrNotFound = errors.New("not found")

func findUser(id int) (*User, error) {
    if id <= 0 {
        return nil, fmt.Errorf("invalid id: %d", id)
    }
    // ... find user
    return nil, ErrNotFound
}

// Usage with error checking
user, err := findUser(1)
if err != nil {
    if errors.Is(err, ErrNotFound) {
        fmt.Println("User not found")
    } else {
        fmt.Printf("Error: %v\\n", err)
    }
    return
}

// Wrap errors (Go 1.13+)
return fmt.Errorf("failed to load: %w", err)''',
          keyPoints: ['nil error = success', 'Always check errors', '%w wraps errors'],
          shortcuts: ['errors.Is() - compare', 'errors.As() - type assert', 'errors.Unwrap() - get wrapped'],
        ),
      ],
    ),

    // Rust
    ProgrammingLanguage(
      name: 'Rust',
      tagline: 'Safety Without Garbage Collection',
      description: 'Memory-safe systems language with zero-cost abstractions.',
      icon: Icons.build,
      primaryColor: const Color(0xFFDEA584),
      secondaryColor: const Color(0xFF000000),
      difficulty: 'Advanced',
      yearCreated: 2010,
      creator: 'Mozilla (Graydon Hoare)',
      useCases: ['Systems Programming', 'WebAssembly', 'CLI Tools', 'Embedded', 'Game Engines'],
      topics: [
        LanguageTopic(
          title: 'Ownership & Borrowing',
          content: 'Rusts unique memory management without garbage collection.',
          codeExample: '''// Ownership - only one owner
let s1 = String::from("hello");
let s2 = s1;  // s1 is moved, no longer valid
// println!("{}", s1);  // ERROR!

// Clone for deep copy
let s1 = String::from("hello");
let s2 = s1.clone();  // Both valid

// Borrowing - references
fn calculate_length(s: &String) -> usize {
    s.len()  // We just borrow, don't own
}

let s = String::from("hello");
let len = calculate_length(&s);  // Pass reference
println!("{} has length {}", s, len);  // s still valid

// Mutable borrowing
fn add_world(s: &mut String) {
    s.push_str(" world");
}''',
          keyPoints: ['One owner at a time', '& for immutable borrow', '&mut for mutable borrow'],
          shortcuts: ['cargo new - create project', 'cargo run - build & run', 'cargo build --release - optimize'],
        ),
        LanguageTopic(
          title: 'Pattern Matching',
          content: 'Powerful match expressions and destructuring.',
          codeExample: '''// Match expression
let number = 13;
match number {
    1 => println!("One!"),
    2 | 3 | 5 | 7 | 11 | 13 => println!("Prime"),
    13..=19 => println!("Teen"),
    _ => println!("Other"),
}

// Option handling
let some_value: Option<i32> = Some(5);
match some_value {
    Some(x) => println!("Got: {}", x),
    None => println!("Nothing"),
}

// if let shorthand
if let Some(x) = some_value {
    println!("Got: {}", x);
}

// Destructuring
let point = (3, 5);
let (x, y) = point;

struct Point { x: i32, y: i32 }
let Point { x, y } = Point { x: 0, y: 7 };''',
          keyPoints: ['match must be exhaustive', '_ is catch-all', 'if let for single pattern'],
          shortcuts: ['todo!() - placeholder', 'unreachable!() - never reached', 'panic!() - crash'],
        ),
        LanguageTopic(
          title: 'Structs & Enums',
          content: 'Custom types with methods and associated functions.',
          codeExample: '''// Struct with methods
struct Rectangle {
    width: u32,
    height: u32,
}

impl Rectangle {
    // Associated function (constructor)
    fn new(w: u32, h: u32) -> Self {
        Rectangle { width: w, height: h }
    }
    
    // Method (takes &self)
    fn area(&self) -> u32 {
        self.width * self.height
    }
    
    // Mutable method
    fn double(&mut self) {
        self.width *= 2;
        self.height *= 2;
    }
}

// Enum with variants
enum Message {
    Quit,
    Move { x: i32, y: i32 },
    Write(String),
    ChangeColor(i32, i32, i32),
}

// Option and Result are enums!
let result: Result<i32, &str> = Ok(42);''',
          keyPoints: ['impl for methods', 'Self is current type', 'Enums can hold data'],
          shortcuts: ['#[derive(Debug)] - debug print', 'dbg!(x) - debug macro', 'Self = current type'],
        ),
        LanguageTopic(
          title: 'Traits',
          content: 'Define shared behavior (like interfaces).',
          codeExample: '''// Define a trait
trait Summary {
    fn summarize(&self) -> String;
    
    // Default implementation
    fn preview(&self) -> String {
        format!("Read more: {}...", &self.summarize()[..50])
    }
}

// Implement trait
struct Article { title: String, content: String }

impl Summary for Article {
    fn summarize(&self) -> String {
        format!("{}: {}", self.title, self.content)
    }
}

// Trait bounds
fn notify(item: &impl Summary) {
    println!("Breaking: {}", item.summarize());
}

// Multiple bounds
fn complex<T: Summary + Clone>(item: &T) { }

// where clause
fn process<T>(item: &T) 
where 
    T: Summary + Clone 
{ }''',
          keyPoints: ['trait defines behavior', 'impl Trait for Type', 'Trait bounds constrain generics'],
          shortcuts: ['impl Trait - parameter', '-> impl Trait - return', 'dyn Trait - dynamic dispatch'],
        ),
        LanguageTopic(
          title: 'Error Handling',
          content: 'Result type for recoverable errors, panic for unrecoverable.',
          codeExample: '''use std::fs::File;
use std::io::{self, Read};

// Result<T, E> for recoverable errors
fn read_file(path: &str) -> Result<String, io::Error> {
    let mut file = File::open(path)?;  // ? propagates error
    let mut contents = String::new();
    file.read_to_string(&mut contents)?;
    Ok(contents)
}

// Using Result
match read_file("hello.txt") {
    Ok(contents) => println!("{}", contents),
    Err(e) => println!("Error: {}", e),
}

// Chaining with ?
fn get_username() -> Result<String, io::Error> {
    let contents = std::fs::read_to_string("user.txt")?;
    Ok(contents.trim().to_string())
}

// unwrap (panics on error) - use carefully!
let f = File::open("file.txt").unwrap();
let f = File::open("file.txt").expect("Custom panic message");''',
          keyPoints: ['? propagates errors', 'unwrap panics on None/Err', 'expect with custom message'],
          shortcuts: ['Ok(T) - success', 'Err(E) - failure', 'Some(T)/None - Option'],
        ),
      ],
    ),

    // Ruby
    ProgrammingLanguage(
      name: 'Ruby',
      tagline: 'Programmer Happiness',
      description: 'Elegant, expressive language designed for developer productivity.',
      icon: Icons.diamond,
      primaryColor: const Color(0xFFCC342D),
      secondaryColor: const Color(0xFFE9573F),
      difficulty: 'Beginner',
      yearCreated: 1995,
      creator: 'Yukihiro Matsumoto',
      useCases: ['Web Development', 'DevOps', 'Scripting', 'Automation', 'Prototyping'],
      topics: [
        LanguageTopic(
          title: 'Variables & Data Types',
          content: 'Dynamic typing with symbols, strings, and numbers.',
          codeExample: '''# Variables
name = "Ruby"
age = 29
pi = 3.14159
is_awesome = true

# Symbols (immutable identifiers)
:status  # More efficient than string
:user_id

# String interpolation
greeting = "Hello, \#{name}!"
puts greeting

# Arrays
fruits = ["apple", "banana", "cherry"]
fruits << "date"  # Append
fruits.push("elderberry")

# Hashes
person = { name: "Alice", age: 25 }
person[:city] = "NYC"
puts person[:name]  # Alice''',
          keyPoints: ['No type declarations', ':symbol for identifiers', '\#{} for interpolation'],
          shortcuts: ['irb - interactive Ruby', 'ruby file.rb - run', 'gem install - packages'],
        ),
        LanguageTopic(
          title: 'Blocks & Iterators',
          content: 'Rubys elegant way to iterate and pass code.',
          codeExample: '''# Block with do...end
[1, 2, 3].each do |num|
  puts num * 2
end

# Block with braces (single line)
[1, 2, 3].map { |n| n * 2 }  # [2, 4, 6]

# Common iterators
(1..5).each { |i| puts i }
5.times { puts "Hello!" }
3.upto(7) { |i| puts i }

# Select (filter)
[1, 2, 3, 4, 5].select { |n| n.even? }  # [2, 4]

# Reduce
[1, 2, 3, 4].reduce(0) { |sum, n| sum + n }  # 10
[1, 2, 3, 4].reduce(:+)  # Shorthand: 10

# Yield in methods
def with_greeting
  puts "Hello!"
  yield  # Call the block
  puts "Goodbye!"
end

with_greeting { puts "Inside block" }''',
          keyPoints: ['do...end for multi-line', '{} for single line', 'yield calls the block'],
          shortcuts: ['.each - iterate', '.map - transform', '.select - filter', '.reduce - accumulate'],
        ),
        LanguageTopic(
          title: 'Classes & Objects',
          content: 'Everything is an object. Clean OOP syntax.',
          codeExample: '''class Person
  # Class variable
  @@count = 0
  
  # Attr accessors (getters/setters)
  attr_accessor :name, :age
  attr_reader :id
  
  # Constructor
  def initialize(name, age)
    @name = name  # Instance variable
    @age = age
    @id = @@count += 1
  end
  
  # Instance method
  def greet
    "Hi, I'm \#{@name}!"
  end
  
  # Class method
  def self.count
    @@count
  end
end

# Inheritance
class Student < Person
  attr_accessor :grade
  
  def initialize(name, age, grade)
    super(name, age)  # Call parent constructor
    @grade = grade
  end
end

alice = Person.new("Alice", 25)
puts alice.greet''',
          keyPoints: ['@ for instance vars', '@@ for class vars', 'attr_accessor auto-generates'],
          shortcuts: ['< for inheritance', 'super calls parent', 'self.method for class method'],
        ),
        LanguageTopic(
          title: 'Modules & Mixins',
          content: 'Organize code and share behavior across classes.',
          codeExample: '''# Module as namespace
module MathUtils
  PI = 3.14159
  
  def self.circle_area(r)
    PI * r * r
  end
end

puts MathUtils::PI
puts MathUtils.circle_area(5)

# Module as mixin
module Debuggable
  def debug
    puts "Class: \#{self.class}"
    puts "ID: \#{object_id}"
  end
end

class Product
  include Debuggable  # Instance methods
  
  def initialize(name)
    @name = name
  end
end

# extend for class methods
class Logger
  extend Debuggable  # Class methods
end

Product.new("Book").debug
Logger.debug''',
          keyPoints: ['include for instance methods', 'extend for class methods', ':: for constants'],
          shortcuts: ['require - load file', 'require_relative - relative path', 'include - mixin'],
        ),
        LanguageTopic(
          title: 'Ruby on Rails Basics',
          content: 'Web framework conventions for rapid development.',
          codeExample: '''# Model (app/models/user.rb)
class User < ApplicationRecord
  has_many :posts
  validates :email, presence: true, uniqueness: true
end

# Controller (app/controllers/users_controller.rb)
class UsersController < ApplicationController
  def index
    @users = User.all
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to @user
    else
      render :new
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email)
  end
end

# Routes (config/routes.rb)
Rails.application.routes.draw do
  resources :users
end''',
          keyPoints: ['MVC architecture', 'Convention over configuration', 'RESTful resources'],
          shortcuts: ['rails new app - create', 'rails s - server', 'rails c - console', 'rails g - generate'],
        ),
      ],
    ),

    // PHP
    ProgrammingLanguage(
      name: 'PHP',
      tagline: 'The Web Backend Language',
      description: 'Powers most of the web including WordPress, Facebook, and Wikipedia.',
      icon: Icons.web,
      primaryColor: const Color(0xFF777BB4),
      secondaryColor: const Color(0xFF4F5B93),
      difficulty: 'Beginner',
      yearCreated: 1995,
      creator: 'Rasmus Lerdorf',
      useCases: ['Web Development', 'WordPress', 'APIs', 'CMS', 'E-commerce'],
      topics: [
        LanguageTopic(
          title: 'Variables & Types',
          content: 'Dynamic typing with \$ prefix for variables.',
          codeExample: '''<?php
// Variables start with \$
\$name = "PHP";
\$age = 29;
\$price = 19.99;
\$isActive = true;

// Arrays
\$fruits = ["apple", "banana", "cherry"];
\$fruits[] = "date";  // Append

// Associative arrays
\$person = [
    "name" => "Alice",
    "age" => 25,
    "city" => "NYC"
];

echo \$person["name"];  // Alice

// String interpolation
echo "Hello, \$name!";        // In double quotes
echo "Age: {\$person['age']}"; // Complex expressions

// Heredoc syntax
\$html = <<<HTML
<div>
    <h1>\$name</h1>
</div>
HTML;
?>''',
          keyPoints: ['\$ for variables', '[] for arrays', '=> for key-value'],
          shortcuts: ['php -v - version', 'php -a - interactive', 'php -S localhost:8000 - dev server'],
        ),
        LanguageTopic(
          title: 'Functions & Closures',
          content: 'Named functions and anonymous functions (closures).',
          codeExample: '''<?php
// Function with types (PHP 7+)
function add(int \$a, int \$b): int {
    return \$a + \$b;
}

// Default parameters
function greet(string \$name = "World"): string {
    return "Hello, \$name!";
}

// Variable arguments
function sum(...\$numbers): int {
    return array_sum(\$numbers);
}

// Closures (anonymous functions)
\$double = function(\$n) {
    return \$n * 2;
};
echo \$double(5);  // 10

// Arrow functions (PHP 7.4+)
\$triple = fn(\$n) => \$n * 3;

// Use for capturing variables
\$factor = 10;
\$multiply = function(\$n) use (\$factor) {
    return \$n * \$factor;
};

// Array functions
\$nums = [1, 2, 3, 4, 5];
\$doubled = array_map(fn(\$n) => \$n * 2, \$nums);
\$evens = array_filter(\$nums, fn(\$n) => \$n % 2 === 0);
?>''',
          keyPoints: ['Type hints optional', 'use for closure scope', 'fn for arrow functions'],
          shortcuts: ['array_map - transform', 'array_filter - filter', 'array_reduce - reduce'],
        ),
        LanguageTopic(
          title: 'Classes & OOP',
          content: 'Full OOP with classes, interfaces, and traits.',
          codeExample: '''<?php
class Person {
    // Properties with visibility
    private string \$name;
    protected int \$age;
    public string \$email;
    
    // Constructor
    public function __construct(string \$name, int \$age) {
        \$this->\$name = \$name;
        \$this->\$age = \$age;
    }
    
    // Getter
    public function getName(): string {
        return \$this->\$name;
    }
    
    // Method
    public function greet(): string {
        return "Hi, I'm {\$this->\$name}!";
    }
}

// Inheritance
class Student extends Person {
    private string \$grade;
    
    public function __construct(string \$name, int \$age, string \$grade) {
        parent::__construct(\$name, \$age);
        \$this->\$grade = \$grade;
    }
}

// Interface
interface Drawable {
    public function draw(): void;
}

// Trait (reusable code)
trait Loggable {
    public function log(string \$msg): void {
        echo "[LOG] \$msg\\n";
    }
}

class Shape implements Drawable {
    use Loggable;
    
    public function draw(): void {
        \$this->log("Drawing shape");
    }
}
?>''',
          keyPoints: ['\$this for instance', '-> for access', 'use for traits'],
          shortcuts: ['public/private/protected', 'extends - inherit', 'implements - interface'],
        ),
        LanguageTopic(
          title: 'Modern PHP (7+)',
          content: 'New features: null coalescing, types, attributes.',
          codeExample: '''<?php
// Null coalescing
\$name = \$_GET["name"] ?? "Guest";

// Null coalescing assignment
\$data["count"] ??= 0;

// Spread operator
\$arr1 = [1, 2, 3];
\$arr2 = [...\$arr1, 4, 5];

// Named arguments (PHP 8)
function createUser(string \$name, int \$age, bool \$admin = false) {}
createUser(name: "Alice", age: 25);

// Constructor promotion (PHP 8)
class Point {
    public function __construct(
        public float \$x,
        public float \$y
    ) {}
}

// Match expression (PHP 8)
\$result = match(\$status) {
    'active' => 'User is active',
    'pending' => 'User is pending',
    default => 'Unknown status',
};

// Attributes (PHP 8)
#[Route("/api/users")]
class UserController {
    #[Get]
    public function index() {}
}
?>''',
          keyPoints: ['?? for null default', 'match for switch', '#[] for attributes'],
          shortcuts: ['??= null assign', '?-> null safe', '... spread'],
        ),
        LanguageTopic(
          title: 'Laravel Basics',
          content: 'Modern PHP framework for web applications.',
          codeExample: '''<?php
// Routes (routes/web.php)
Route::get('/users', [UserController::class, 'index']);
Route::post('/users', [UserController::class, 'store']);
Route::resource('posts', PostController::class);

// Controller
class UserController extends Controller {
    public function index() {
        \$users = User::all();
        return view('users.index', compact('users'));
    }
    
    public function store(Request \$request) {
        \$validated = \$request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|email|unique:users',
        ]);
        
        \$user = User::create(\$validated);
        return redirect()->route('users.show', \$user);
    }
}

// Model (app/Models/User.php)
class User extends Model {
    protected \$fillable = ['name', 'email'];
    
    public function posts() {
        return \$this->hasMany(Post::class);
    }
}

// Blade template
@foreach(\$users as \$user)
    <p>{{ \$user->name }}</p>
@endforeach
?>''',
          keyPoints: ['Eloquent ORM', 'Blade templates', 'Artisan CLI'],
          shortcuts: ['php artisan serve - dev server', 'php artisan make:model - generate', 'php artisan migrate - database'],
        ),
      ],
    ),
  ];

  /// Get language by name
  static ProgrammingLanguage? getLanguage(String name) {
    try {
      return allLanguages.firstWhere(
        (lang) => lang.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  /// Search languages by query
  static List<ProgrammingLanguage> searchLanguages(String query) {
    query = query.toLowerCase();
    return allLanguages.where((lang) {
      return lang.name.toLowerCase().contains(query) ||
          lang.tagline.toLowerCase().contains(query) ||
          lang.description.toLowerCase().contains(query) ||
          lang.useCases.any((use) => use.toLowerCase().contains(query));
    }).toList();
  }

  /// Get languages by difficulty
  static List<ProgrammingLanguage> getByDifficulty(String difficulty) {
    return allLanguages
        .where((lang) => lang.difficulty == difficulty)
        .toList();
  }
}
