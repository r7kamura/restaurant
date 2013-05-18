# Example
This is an example app of Restaurant.

## Specification
```
/v1/recipes
  GET /v1/recipes
    return recipes
    with filter query
      filters recipes
    with sort query
      sorts recipes
    with page query
      paginates recipes
  GET /v1/recipes/:id
    with existent id
      returns the recipe
    with non-existent id
      returns 404
    with invalid id
      returns 404
  POST /v1/recipes
    creates a new recipe
  PUT /v1/recipes/:id
    with existent id
      updates the recipe
    with non-existent id
      returns 404
  DELETE /v1/recipes/:id
    with existent id
      deletes the recipe
    with non-existent id
      returns 404

/v2/recipes
  POST /v2/recipes
    without authentication
      returns 401
    about authorization
      without authorization
        returns 403
      with authorization
        creates a new recipe
```
