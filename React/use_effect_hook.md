# use_effect_hook.md

## The `useEffect` Hook

The `useEffect` hook lets you perform **side effects** in functional components. Side effects are operations that interact with the "outside world" beyond the component's rendering logic, such as fetching data, setting up subscriptions, or manually manipulating the DOM.

`useEffect` serves as a combination of lifecycle methods found in class components, like `componentDidMount`, `componentDidUpdate`, and `componentWillUnmount`, but with a more unified and flexible API.

### Purpose

*   To manage operations that are not directly related to rendering the UI but are necessary for the component's functionality.
*   To synchronize a component with an external system (like an API, browser APIs, timers, or third-party libraries).

### What are Side Effects?

In the context of React components (which are ideally pure functions of their props and state), side effects include:

*   Fetching data from an API.
*   Setting up or tearing down subscriptions (e.g., to WebSockets, browser events, external data sources).
*   Manually changing the DOM (though this should be rare; usually refs are preferred if needed).
*   Setting timers (`setTimeout`, `setInterval`).
*   Logging.

### How to Use It

1.  **Import:** Import `useEffect` from the 'react' library.
    ```javascript
    import React, { useState, useEffect } from 'react';
    ```
2.  **Declare Effect:** Call `useEffect` at the top level of your functional component.
    *   It takes two arguments:
        1.  A **callback function** containing the side effect logic.
        2.  An optional **dependency array**.

    ```jsx
    function MyComponent({ userId }) {
      const [data, setData] = useState(null);

      useEffect(() => {
        // Side effect logic goes here
        console.log('Effect ran!');
        // Example: Fetch data based on userId prop
        fetch(`/api/users/${userId}`)
          .then(response => response.json())
          .then(userData => setData(userData));

      }, [userId]); // Dependency array

      // ... rest of the component rendering 'data'
    }
    ```

### Controlling When Effects Run: The Dependency Array

The **dependency array** (the second argument) is crucial. It tells React *when* to re-run the effect function.

1.  **No Dependency Array (`useEffect(callback)`):**
    *   The effect runs **after every single render** (initial render and all subsequent re-renders).
    *   Use this sparingly, as it can cause performance issues or infinite loops if the effect itself triggers a state update.

    ```jsx
    useEffect(() => {
      console.log('Component rendered or updated');
      // Runs after every render
    });
    ```

2.  **Empty Dependency Array (`useEffect(callback, [])`):**
    *   The effect runs **only once**, right after the **initial render**.
    *   This is the equivalent of `componentDidMount` in class components.
    *   Ideal for:
        *   One-time data fetching.
        *   Setting up subscriptions or timers that don't depend on props or state.

    ```jsx
    useEffect(() => {
      console.log('Component mounted');
      // Fetch initial data, set up global listener, etc.
      const subscription = setupSubscription();
      // Cleanup needed! (See below)
      return () => {
        subscription.unsubscribe();
      }
    }, []); // Empty array means run only once
    ```

3.  **Dependency Array with Values (`useEffect(callback, [dep1, dep2])`):**
    *   The effect runs **after the initial render** *and* **any time one of the values in the dependency array changes** between renders. React performs a shallow comparison of the dependency values.
    *   This is similar to `componentDidUpdate` but more targeted, preventing unnecessary effect runs.
    *   Include **all values** (props, state, context values, functions defined in the component) that are used inside the effect function and could change over time.
    *   Forgetting a dependency can lead to stale closures (the effect function "remembers" old values of props or state). ESLint rules often help catch missing dependencies.

    ```jsx
    useEffect(() => {
      console.log(`Fetching data for user ${userId}`);
      // Fetch data whenever userId changes
      fetch(`/api/users/${userId}`)
        .then(res => res.json())
        .then(setData);
    }, [userId]); // Re-run effect if userId changes
    ```

### Cleanup Function

Often, side effects need cleanup to prevent memory leaks or unwanted behavior (e.g., unsubscribing, clearing timers, removing event listeners).

*   **How:** Return a function from within the `useEffect` callback. This returned function is the **cleanup function**.
*   **When it Runs:**
    *   Before the component unmounts (equivalent to `componentWillUnmount`).
    *   *Before* the effect runs again due to a dependency change (except for the very first run). This ensures the previous effect is cleaned up before the next one starts.
*   **Purpose:** To clean up any resources established by the effect.

```jsx
useEffect(() => {
  // Effect: Set up an interval timer
  const intervalId = setInterval(() => {
    console.log('Tick');
  }, 1000);

  console.log(`Timer started with ID: ${intervalId}`);

  // Cleanup function: Clear the interval when component unmounts
  // or before the effect runs again (if dependencies were present)
  return () => {
    console.log(`Clearing timer with ID: ${intervalId}`);
    clearInterval(intervalId);
  };
}, []); // Empty array: runs once on mount, cleans up on unmount
