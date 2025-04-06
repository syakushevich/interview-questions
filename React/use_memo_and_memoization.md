# use_memo_and_memoization.md

## Memoization in Computing

**Memoization** is an optimization technique used primarily to speed up computer programs by storing the results of expensive function calls and returning the cached result when the same inputs occur again.

*   **Concept:** If a function is "pure" (meaning it always returns the same output for the same input and has no side effects), you can cache its results. The first time the function is called with specific inputs, its result is calculated and stored. Subsequent calls with the identical inputs simply retrieve the stored result without re-executing the function's logic.
*   **Benefit:** Avoids redundant computation, saving processing time, especially for functions that perform complex calculations.

## Memoization in React

In React, components re-render whenever their state or props change. Sometimes, calculations performed *during* the rendering process can be computationally expensive. If these calculations are repeated on every render even when their inputs haven't changed, it can negatively impact performance.

React provides hooks and utilities to apply memoization techniques, preventing unnecessary re-calculations or re-renders.

## The `useMemo` Hook

The `useMemo` hook is specifically designed to **memoize the result (value) of a calculation** within a functional component.

### Purpose

*   To avoid re-computing expensive values on every render if the dependencies used in the calculation haven't changed.
*   To preserve **referential equality** for objects or arrays that are passed down as props to memoized child components (using `React.memo`). If you create a new object/array literal on every render, child components memoized with `React.memo` might re-render unnecessarily because the prop reference changes, even if the content is the same. `useMemo` can return the *same* object/array reference if dependencies are unchanged.

### How to Use It

1.  **Import:** Import `useMemo` from the 'react' library.
    ```javascript
    import React, { useState, useMemo } from 'react';
    ```
2.  **Declare Memoized Value:** Call `useMemo` at the top level of your functional component.
    *   It takes two arguments:
        1.  A **"create" function** that performs the expensive calculation and returns the value you want to memoize.
        2.  A **dependency array**.

    ```jsx
    function ExpensiveCalculationComponent({ a, b }) {
      // This calculation might be slow
      const computeExpensiveValue = (num1, num2) => {
        console.log('Calculating expensive value...');
        // Simulate a slow calculation
        let sum = 0;
        for (let i = 0; i < 1000000000; i++) {
          sum += i; // Just an example of work
        }
        return num1 + num2 + (sum * 0); // Use sum to prevent optimization removal
      };

      // useMemo will only re-run computeExpensiveValue if 'a' or 'b' changes
      const memoizedValue = useMemo(() => computeExpensiveValue(a, b), [a, b]);

      return (
        <div>
          <p>Prop a: {a}</p>
          <p>Prop b: {b}</p>
          <p>Expensive Calculation Result: {memoizedValue}</p>
        </div>
      );
    }
    ```

### The Dependency Array

*   Similar to `useEffect`, the dependency array controls when the calculation function inside `useMemo` is re-executed.
*   `useMemo(calculateValue, [dep1, dep2])`: The `calculateValue` function will only be re-run if any of the dependencies (`dep1`, `dep2`) have changed since the last render.
*   If the dependencies haven't changed, `useMemo` returns the previously calculated (memoized) value without executing the function again.
*   An empty dependency array (`[]`) means the value will be calculated only once on the initial render and never recalculated.
*   Omitting the dependency array is generally not recommended as it defeats the purpose of memoization (it would run on every render).

### When to Use `useMemo`

1.  **Computationally Expensive Calculations:** When a calculation within your component takes significant time and its inputs don't change on every render. Profile your application first to confirm the calculation is actually a bottleneck.
2.  **Referential Equality Optimization:** When passing objects or arrays as props to child components that are wrapped in `React.memo`. `useMemo` can ensure you pass the *same object/array reference* if the underlying data hasn't changed, preventing unnecessary re-renders of the memoized child.

    ```jsx
    import React, { useState, useMemo } from 'react';
    import MemoizedChildComponent from './MemoizedChildComponent'; // Assume this is wrapped in React.memo

    function ParentComponent({ listData }) {
      const [filter, setFilter] = useState('');

      // Without useMemo, filteredList would be a new array reference on every render,
      // causing MemoizedChildComponent to re-render even if listData and filter are the same.
      const filteredList = useMemo(() => {
        console.log('Filtering list...');
        return listData.filter(item => item.includes(filter));
      }, [listData, filter]); // Only re-filter when listData or filter changes

      return (
        <div>
          <input type="text" value={filter} onChange={e => setFilter(e.target.value)} />
          {/* Pass the memoized array reference */}
          <MemoizedChildComponent list={filteredList} />
        </div>
      );
    }
    ```

### When *Not* to Use `useMemo`

*   **Premature Optimization:** Don't wrap every calculation in `useMemo`. It adds complexity and has its own minor overhead. Only use it when you have identified a performance issue or need stable references.
*   **Simple Calculations:** Calculations that are already very fast don't benefit from `useMemo`.

### `useMemo` vs. `React.memo` vs. `useCallback`

*   `useMemo`: Memoizes a **value** (the result of a function call).
*   `React.memo`: A Higher-Order Component (HOC) that memoizes a **component**, preventing re-renders if its props haven't changed (shallow comparison).
*   `useCallback`: Memoizes a **function callback** itself, primarily used to pass stable function references down to memoized child components. `useCallback(fn, deps)` is equivalent to `useMemo(() => fn, deps)`.

### Rules of Hooks

`useMemo` must follow the Rules of Hooks:

1.  **Only call Hooks at the top level.**
2.  **Only call Hooks from React function components or custom Hooks.**

### Summary

`useMemo` is a performance optimization hook in React. It memoizes the result of expensive calculations, recomputing the value only when its specified dependencies change. It's also useful for maintaining referential stability for non-primitive values passed as props to memoized child components. Use it judiciously when performance profiling indicates a need or for referential equality optimizations.
