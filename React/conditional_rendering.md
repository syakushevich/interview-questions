# conditional_rendering.md

## Conditional Rendering in React

Conditional rendering is the process of displaying different UI elements or components based on certain conditions, typically derived from the component's **state** or **props**. It allows you to create dynamic and responsive user interfaces that adapt to changing data or user interactions.

### Why is it Essential?

React applications are rarely static. You constantly need to:

*   Show a loading indicator while data is being fetched.
*   Display user-specific content only if the user is logged in.
*   Render error messages if something goes wrong.
*   Toggle UI elements based on user actions (e.g., showing/hiding a modal).
*   Render different layouts based on screen size or other factors.

Conditional rendering provides the mechanism to handle these scenarios declaratively within your components.

### Common Techniques

React leverages standard JavaScript operators and techniques for conditional rendering directly within JSX or in the component's logic.

1.  **`if` Statements (Outside JSX)**

    You can use standard JavaScript `if`/`else if`/`else` statements outside your JSX block to determine which component or element variable to render.

    ```jsx
    import React, { useState } from 'react';

    function LoginStatusMessage(props) {
      const isLoggedIn = props.isLoggedIn;
      let messageElement; // Variable to hold the element to render

      if (isLoggedIn) {
        messageElement = <h1>Welcome back!</h1>;
      } else {
        messageElement = <h1>Please sign up.</h1>;
      }

      return <div>{messageElement}</div>; // Render the chosen element
    }

    function App() {
      const [loggedIn, setLoggedIn] = useState(false);
      return (
        <div>
          <LoginStatusMessage isLoggedIn={loggedIn} />
          <button onClick={() => setLoggedIn(!loggedIn)}>
            Toggle Login
          </button>
        </div>
      );
    }
    ```

2.  **Inline Ternary Operator (`condition ? exprIfTrue : exprIfFalse`)**

    This is a concise way to handle simple `if/else` conditions directly within JSX. It's often used for switching between two possible outputs.

    ```jsx
    import React, { useState } from 'react';

    function LoginStatusMessageTernary({ isLoggedIn }) {
      return (
        <div>
          {isLoggedIn
            ? <h1>Welcome back!</h1> // Rendered if isLoggedIn is true
            : <h1>Please sign up.</h1> // Rendered if isLoggedIn is false
          }
        </div>
      );
    }

    function App() {
      const [loggedIn, setLoggedIn] = useState(false);
      return (
        <div>
          <LoginStatusMessageTernary isLoggedIn={loggedIn} />
          <button onClick={() => setLoggedIn(!loggedIn)}>
            Toggle Login
          </button>
        </div>
      );
    }
    ```

3.  **Inline Logical `&&` Operator (`condition && expression`)**

    This technique is useful when you want to render an element *only if* a condition is true. If the condition is `true`, the expression *after* `&&` is rendered. If the condition is `false`, React ignores the expression and renders nothing (`null`).

    *   **How it works:** In JavaScript, `true && expression` always evaluates to `expression`, and `false && expression` always evaluates to `false`. React doesn't render `false`, `null`, or `undefined`.

    ```jsx
    import React from 'react';

    function Mailbox({ unreadMessages }) {
      const messageCount = unreadMessages.length;
      return (
        <div>
          <h1>Hello!</h1>
          {/* Only render the message count if there are unread messages */}
          {messageCount > 0 &&
            <h2>
              You have {messageCount} unread messages.
            </h2>
          }
        </div>
      );
    }

    function App() {
        const messages = ['React', 'Re: React', 'Re:Re: React'];
        // const messages = []; // Try with an empty array
        return <Mailbox unreadMessages={messages} />;
    }
    ```

4.  **Preventing Rendering with `null`**

    In some cases, you might want a component to render nothing based on a condition. You can achieve this by returning `null` from the component's render logic. This is often used within components that conditionally render themselves.

    ```jsx
    import React from 'react';

    function WarningBanner({ warn }) {
      if (!warn) {
        // If the 'warn' prop is false, render nothing.
        return null;
      }

      // Otherwise, render the warning message.
      return (
        <div className="warning">
          Warning!
        </div>
      );
    }

    function App() {
      const [showWarning, setShowWarning] = React.useState(true);

      const handleToggleClick = () => {
        setShowWarning(prevShowWarning => !prevShowWarning);
      }

      return (
        <div>
          <WarningBanner warn={showWarning} />
          <button onClick={handleToggleClick}>
            {showWarning ? 'Hide' : 'Show'} Warning
          </button>
        </div>
      );
    }
    ```

### Choosing a Technique

*   Use **`if` statements** for more complex logic outside JSX or when readability is improved by separating the logic.
*   Use the **ternary operator** for simple inline `if/else` conditions.
*   Use the **logical `&&` operator** for rendering something *only if* a condition is true.
*   Return **`null`** if a component should hide itself completely based on props or state.

Conditional rendering is a fundamental pattern used constantly in React to create dynamic and interactive user interfaces based on application state and user input.
