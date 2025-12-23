export const handler = async (event) => {
  // Parse the input (assume it's JSON)
  const { bookName, bookTitle, bookAuthor, bookGenre, publishedYear } = event;

  // Generate random id and timestamps
  const id = Math.random().toString(36).substr(2, 9);
  const timestamp = new Date().toISOString();

  // Build the book object
  const book = {
    id,
    bookName,
    bookTitle,
    bookAuthor,
    bookGenre,
    publishedYear,
    createdAt: timestamp,
    updatedAt: timestamp
  };

  // Return the response
  return {
    statusCode: 200,
    body: book
  };
};
