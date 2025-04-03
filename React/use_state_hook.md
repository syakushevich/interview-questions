# use_state_hook.md

## The `useState` Hook

The `useState` hook is the fundamental React Hook that allows you to add **state variables** to **functional components**. Before hooks, state was primarily managed in class components using `this.state` and `this.setState()`. `useState` brings this capability to the simpler functional component syntax.

### Purpose

*   To declare and manage stateful data within a functional component.
*   To trigger re-renders of the component whenever the state value changes, ensuring the UI stays synchronized with the data.

### How to Use It

1.  **Import:** Import `useState` from the 'react' library.
    ```javascript
    import React, { useState } from 'react';
    ```
2.  **Declare State:** Call `useState` at the top level of your functional component.
    *   It takes one argument: the **initial state** value. This can be a primitive (string, number, boolean, null, undefined) or an object/array. This initial value is used only during the *first* render.
    *   It returns an array containing exactly two elements:
        1.  The **current state value**.
        2.  A **setter function** to update that state value.
3.  **Array Destructuring:** Use array destructuring to assign names to the state value and the setter function. This is the standard convention.

    ```jsx
    function MyComponent() {
      // Declare a state variable named 'count' initialized to 0
      // 'setCount' is the function to update 'count'
      const [count, setCount] = useState(0);

      // Declare another state variable named 'name' initialized to 'Guest'
      const [name, setName] = useState('Guest');

      // ... rest of the component
    }
    ```

4.  **Read State:** Use the state variable directly in your JSX or component logic.

    ```jsx
      return (
        <div>
          <p>Hello, {name}!</p> {/* Read the 'name' state */}
          <p>Count: {count}</p> {/* Read the 'count' state */}
          {/* ... buttons or inputs to update state */}
        </div>
      );
    ```

5.  **Update State:** Call the setter function provided by `useState` to update the state.
    *   **Important:** Calling the setter function does two things:
        1.  It schedules an update to the state variable with the new value you provide.
        2.  It triggers a re-render of the component (and its children) so the UI reflects the new state.
    *   **Never mutate state directly.** Always use the setter function.

    ```jsx
      const handleIncrement = () => {
        // Call the setter function to update the state
        setCount(count + 1);
      };

      const handleNameChange = (event) => {
        setName(event.target.value);
      };

      return (
        <div>
          {/* ... display state ... */}
          <button onClick={handleIncrement}>Increment Count</button>
          <input type="text" value={name} onChange={handleNameChange} />
        </div>
      );
    ```

### Updating State Based on Previous State

If the new state depends on the previous state value (like in a counter), it's safer to pass a **function** to the setter. This function receives the previous state as an argument and should return the new state. React guarantees that the `prevState` value passed to this function will be up-to-date, preventing potential issues caused by asynchronous state updates or batching.

```jsx
  const handleIncrementSafely = () => {
    // Pass a function to the setter
    setCount(prevCount => prevCount + 1);
  };

  const handleDecrementSafely = () => {
    setCount(prevCount => prevCount - 1);
  };
