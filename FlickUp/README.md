# FlickUp 
(To get a picture..from Flickr API)

It is a application that uses Flickr image search API that shows the result in  a grid view.

Features that are inclueded in the application and points for better understanding of application:-

1. Uses UISearchViewController as the title view of navigation view to provide search action for users.
2. Showing the result in the UICollectionView in pattern of 3-column scroll view.
3. Integartion of Flickr search API.
4. Lazy image loading feature in collection view
5. Managing multiple download tasks by checking if downlaod task for url already exists.
6. Managing between high and low task priorities depending on whether particular cell visibility.
7. Supported Image caching to save time from several dowloads of same image.
8. Supported switching from low to high resolution image from collection view to detail view. Used thumbnail image URL to download image in collection cell and high resolution image URL for detailed view.
