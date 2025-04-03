# components_functional_vs_class_composition.md

## Components in React

Components are the core building blocks of React applications. They are independent, reusable pieces of UI. Think of them like JavaScript functions or classes that accept inputs (props) and return React elements describing what should appear on the screen.

### Functional Components (Preferred)

*   **Definition:** Simple JavaScript functions that accept a `props` object as an argument and return JSX.
*   **Modern Standard:** The recommended way to write components in modern React.
*   **Simplicity:** Generally more concise and easier to read, test, and reason about than class components.
*   **State & Lifecycle:** Use **Hooks** (like `useState`, `useEffect`, `useContext`) to add state, handle side effects, and access other React features previously only available in class components.
*   **No `this` Keyword:** Avoids the complexities associated with the `this` keyword in JavaScript classes.

*   **Example:**

    ```jsx
    import React, { useState, useEffect } from 'react';

    // Simple functional component receiving props
    function Welcome(props) {
      return <h1>Hello, {props.name}</h1>;
    }

    // Functional component using hooks for state and effects
    function Counter({ initialCount = 0 }) {
      const [count, setCount] = useState(initialCount);

      useEffect(() => {
        // Example side effect: Update document title
        document.title = `Count: ${count}`;
        // Cleanup function (optional)
        return () => {
          document.title = 'React App';
        };
      }, [count]); // Dependency array: effect runs only when count changes

      return (
        <div>
          <p>Count: {count}</p>
          <button onClick={() => setCount(count + 1)}>Increment</button>
        </div>
      );
    }
    ```

### Class Components (Legacy/Older Approach)

*   **Definition:** ES6 classes that extend `React.Component`.
*   **Render Method:** Must define a `render()` method that returns JSX.
*   **Props:** Accessed via `this.props`.
*   **State:** Managed using `this.state` (initialized in the `constructor`) and updated using `this.setState()`. `setState()` triggers a re-render.
*   **Lifecycle Methods:** Have built-in lifecycle methods (e.g., `componentDidMount`, `componentDidUpdate`, `componentWillUnmount`) to run code at specific points in the component's life. Hooks like `useEffect` provide equivalent functionality in functional components.
*   **`this` Keyword:** Requires careful handling of the `this` keyword, often needing binding in the constructor for event handlers.

*   **Example:**

    ```jsx
    import React from 'react';

    class WelcomeClass extends React.Component {
      render() {
        // Access props via this.props
        return <h1>Hello, {this.props.name}</h1>;
      }
    }

    class CounterClass extends React.Component {
      constructor(props) {
        super(props);
        // Initialize state in the constructor
        this.state = {
          count: props.initialCount || 0,
        };
        // Bind event handlers (necessary for 'this' context)
        // this.increment = this.increment.bind(this); // Or use arrow function syntax
      }

      componentDidMount() {
        // Example lifecycle method
        document.title = `Count: ${this.state.count}`;
      }

      componentDidUpdate(prevProps, prevState) {
        // Example lifecycle method
        if (prevState.count !== this.state.count) {
          document.title = `Count: ${this.state.count}`;
        }
      }

      componentWillUnmount() {
        // Example lifecycle method (cleanup)
        document.title = 'React App';
      }

      // Use arrow function for automatic 'this' binding
      increment = () => {
        // Update state using this.setState
        this.setState(prevState => ({
          count: prevState.count + 1,
        }));
      };

      render() {
        return (
          <div>
            <p>Count: {this.state.count}</p>
            <button onClick={this.increment}>Increment</button>
          </div>
        );
      }
    }
    ```

### Functional vs. Class Components Summary

| Feature             | Functional Components              | Class Components                     |
| :------------------ | :--------------------------------- | :----------------------------------- |
| **Syntax**          | JavaScript function                | ES6 class extending `React.Component`|
| **Props Access**    | Function argument (`props`)        | `this.props`                         |
| **State**           | `useState`, `useReducer` hooks     | `this.state`, `this.setState()`      |
| **Lifecycle**       | `useEffect` hook (and others)      | Lifecycle methods (e.g., `componentDidMount`)|
| **`this` Keyword**  | Not used                           | Required, needs binding              |
| **Conciseness**     | Generally more concise             | More verbose                         |
| **Modern Practice** | **Preferred**                      | Less common for new code             |

### Composition

*   **Concept:** React follows a strong **composition model**. Instead of inheriting functionality from a base component (like in some object-oriented paradigms), you build complex UIs by combining smaller, focused components.
*   **How it Works:** Components can render other components. Props are used to pass data and configuration down the composition tree. The `children` prop is a special prop that allows components to render arbitrary content passed between their opening and closing tags.
*   **Benefits:** Promotes reusability, maintainability, and separation of concerns. Makes components more flexible and easier to test.
*   **Inheritance:** Generally avoided in React for component code reuse. Composition and Hooks are the preferred patterns.

*   **Example:**

    ```jsx
    // Simple reusable Button component
    function Button(props) {
      // props.children renders whatever is between <Button> and </Button>
      return <button className={`btn ${props.type}`}>{props.children}</button>;
    }

    // Card component that uses Button and accepts children
    function Card(props) {
      return (
        <div className="card">
          <h2>{props.title}</h2>
          <div className="card-content">{props.children}</div>
        </div>
      );
    }

    // App component composing Card and Button
    function App() {
      return (
        <div>
          <Card title="Welcome!">
            <p>This content is passed as children to the Card component.</p>
            <Button type="primary">Click Me</Button>
            <Button type="secondary">Learn More</Button>
          </Card>
        </div>
      );
    }
    ```

In this example, `App` *composes* `Card`, and `Card` *composes* `Button` and renders its own `children`. This compositional approach is fundamental to building React applications.
