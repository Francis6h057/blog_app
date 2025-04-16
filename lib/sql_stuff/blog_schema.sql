-- Create a table for public blogs
create table blogs (
  -- Unique ID for each blog post
  id uuid not null primary key,

  -- Timestamp to track when the blog was last updated
  updated_at timestamp with time zone,

  -- ID of the user who posted the blog (references the profiles table)
  poster_id uuid not null,

  -- Title of the blog post (required)
  title text not null,

  -- Main content of the blog post (required)
  content text not null,

  -- Optional image URL related to the blog post
  image_url text,

  -- Optional list of topics/tags for the blog
  topics text array,

  -- Foreign key linking the blog post to a user profile
  foreign key (poster_id) references public.profiles(id)
);

-- Enable Row Level Security (RLS) on the blogs table
alter table blogs
  enable row level security;

-- Allow anyone (even unauthenticated users) to read (select) blogs
create policy "Public blogs are viewable by everyone." on blogs
  for select using (true);

-- Allow users to insert (create) their own blogs
-- BUT: there's a logic error here: `auth.uid()` is compared to `id`, which is the blog ID, not the user.
-- It should probably compare to `poster_id`
create policy "Users can insert their own blogs." on blogs
  for insert with check ((select auth.uid()) = id);

-- Allow users to update only their own blogs
-- Same issue as above: should compare `auth.uid()` to `poster_id`, not `id`
create policy "Users can update own blogs." on blogs
  for update using ((select auth.uid()) = id);
