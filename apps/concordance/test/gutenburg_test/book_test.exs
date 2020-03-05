defmodule GutenburgTest.BookTest do
  use ExUnit.Case
  alias Gutenburg.Book
  alias Parsing.TextSection

  test "can parse book title out of book" do
    hyde_text = "The Project Gutenberg EBook of The Strange Case Of Dr. Jekyll And Mr.\r\nHyde, by Robert Louis Stevenson

    This eBook is for the use of anyone anywhere at no cost and with
    almost no restrictions whatsoever.You may copy it, give it away or
    re-use it under the terms of the Project Gutenberg License included
    with this eBook or online at www.gutenberg.org


    Title: The Strange Case Of Dr. Jekyll And Mr. Hyde

    Author: Robert Louis Stevenson

    Release Date: June 25, 2008 [EBook #43]
    Last Updated: December 6, 2018

    Language: English

    Character set encoding: UTF-8


    *** START OF THIS PROJECT GUTENBERG EBOOK
    THE STRANGE CASE OF DR. JEKYLL AND MR. HYDE ***


    Produced by David Widger"

    actual = Book.get_title(hyde_text)

    expected_title = "The Project Gutenberg EBook of The Strange Case Of Dr. Jekyll And Mr."

    assert actual == expected_title
  end

  test "can split book to sections" do
    book = %Book{
      id: 0,
      title: "Warbringer",
      text: "This book has five words"
    }
    section_length = 2
    actual_sections = Book.split_into_sections(book, section_length) |> Enum.sort
    expected_sections = [
      %TextSection{
        book_title: book.title,
        word_offset: 0,
        text: "This book"
      },
      %TextSection{
        book_title: book.title,
        word_offset: 2,
        text: "has five"
      },
      %TextSection{
        book_title: book.title,
        word_offset: 4,
        text: "words"
      }
    ] |> Enum.sort
    assert actual_sections == expected_sections
  end

end
