-- Create a table for public profiles
create table profiles (
  -- 'id' is the primary key and also references the 'auth.users' table's 'id'
  id uuid references auth.users not null primary key,

  -- Timestamp to track when the profile was last updated
  updated_at timestamp with time zone,

  -- User's name (can be displayed publicly)
  name text,

  -- Constraint to ensure the name is at least 3 characters long
  constraint name_length check (char_length(name) >= 3)
);

-- Enable Row Level Security (RLS) on the 'profiles' table
-- RLS allows fine-grained access control on a per-row basis
alter table profiles
  enable row level security;

-- Policy that allows anyone to select (read) public profiles
create policy "Public profiles are viewable by everyone." on profiles
  for select using (true);

-- Policy that allows users to insert (create) their own profile
create policy "Users can insert their own profile." on profiles
  for insert with check ((select auth.uid()) = id);

-- Policy that allows users to update only their own profile
create policy "Users can update own profile." on profiles
  for update using ((select auth.uid()) = id);

-- Function to automatically insert a profile when a new user signs up
-- This pulls the user's name from their sign-up metadata
create function public.handle_new_user()
returns trigger                         -- This is a trigger function
set search_path = ''                    -- Avoids unexpected schema conflicts
as $$
begin
  -- Insert a new row into 'profiles' using the new user's ID and name from metadata
  insert into public.profiles (id, name)
  values (new.id, new.raw_user_meta_data->>'name');
  return new;                           -- Return the newly inserted user row
end;
$$ language plpgsql security definer;   -- Defines the language and privileges

-- Create the actual trigger that runs after a new user is inserted in 'auth.users'
create trigger on_auth_user_created
  after insert on auth.users                -- Trigger fires after a new user is added
  for each row execute procedure public.handle_new_user(); -- Calls the function above
