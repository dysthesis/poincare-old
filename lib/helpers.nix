{
  # Syntactic sugar, similar to Haskell's Either.
  either = left: right:
    if left != null
    then left
    else right;
}
