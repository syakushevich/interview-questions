# state_and_props.md

## State and Props in React

State and Props are fundamental concepts for managing and passing data within React applications. Understanding their differences and how they work together is crucial for building dynamic UIs.

### Props (Properties)

*   **Definition:** Props (short for properties) are arguments passed *into* React components from their parent component. They are analogous to function arguments.
*   **Purpose:**
    *   To pass data down the component tree (from parent to child).
    *   To configure a component's appearance or behavior.
    *   To pass callback functions down, allowing children to communicate events back up to parents.
*   **Data Flow:** Unidirectional (one-way) – data flows down from parent to child.
*   **Mutability:** **Immutable**. A component cannot directly modify the props it receives. If a change is needed based on child interaction, the child typically calls a function passed down *as a prop* from the parent.
*   **Access:**
    *   In functional components: Received as the first argument (often destructured).
    *   In class components: Accessed via `this.props`.

*   **Example (Functional Component):**

    ```jsx
    // Parent Component
    function App() {
      const userName = "Alice";
      return <UserProfile name={userName} age={30} />;
    }

    // Child Component (using destructuring)
    function UserProfile({ name, age }) {
      // Props 'name' and 'age' are received from App
      return (
        <div>
          <h1>{name}</h1>
          <p>Age: {age}</p>
        </div>
      );
    }
    ```

### State

*   **Definition:** State represents data that is managed *internally* by a component. It's data that can change over time due to user interactions, network responses, or other events. Think of it as the component's private memory.
*   **Purpose:**
    *   To store data specific to the component that will change during its lifecycle.
    *   To make components interactive.
    *   To trigger re-renders of the component when the data changes, keeping the UI synchronized.
*   **Data Flow:** Managed and updated *within* the component itself. State updates can trigger re-renders, potentially causing new props to be passed down to child components.
*   **Mutability:** **Mutable**, but *only* via specific update functions provided by React.
    *   **Crucially: Never mutate state directly.** Modifying state directly (e.g., `myStateVariable.key = 'new'`) will not trigger a re-render and breaks React's assumptions.
*   **Management:**
    *   In functional components: Using the `useState` hook (or `useReducer` for more complex logic). `useState` returns the current state value and a function to update it.
    *   In class components: Initialized in the `constructor` (`this.state = {...}`) and updated using `this.setState({...})`.

*   **Example (Functional Component with `useState`):**

    ```jsx
    import React, { useState } from 'react';

    function Counter() {
      // Declare a state variable 'count', initialized to 0
      // 'setCount' is the function to update 'count'
      const [count, setCount] = useState(0);

      const increment = () => {
        // Update state using the setter function (immutable update)
        setCount(prevCount => prevCount + 1); // Recommended way for updates based on previous state
        // Or: setCount(count + 1);
      };

      return (
        <div>
          <p>You clicked {count} times</p>
          <button onClick={increment}>Click me</button>
        </div>
      );
    }
    ```

### Key Differences Summarized

| Feature        | Props                                    | State                                          |
| :------------- | :--------------------------------------- | :--------------------------------------------- |
| **Origin**     | Passed from parent component             | Managed within the component                   |
| **Mutability** | Immutable (read-only by component)       | Mutable (via setter functions)                 |
| **Purpose**    | Configure component, pass data down    | Manage internal, changing data, trigger render |
| **Access**     | `props` object / function argument     | `useState`/`useReducer` hooks / `this.state`   |
| **Updates By** | Parent component re-render             | Internal calls to setter functions             |

### Immutability Importance

Always treat state as immutable. When updating state based on previous state (especially for objects and arrays), create *new* objects or arrays instead of modifying the existing ones directly.

**Why?** React relies on reference equality (shallow comparison) for performance optimizations (like `React.memo` or determining if a re-render is needed). If you mutate state directly, the reference doesn't change, and React might skip necessary updates. Creating new objects/arrays ensures the reference changes, allowing React's change detection to work correctly.

**Example (Updating an object in state):**

```jsx
const [user, setUser] = useState({ name: 'Bob', age: 30 });

// Correct way to update age
setUser(currentUser => ({
  ...currentUser, // Copy existing properties
  age: currentUser.age + 1 // Overwrite the age property
}));

// Incorrect way (mutation)
// user.age = 31;
// setUser(user); // This might not trigger a re-render!
