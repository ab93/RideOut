package com.hackathon.cmc.activity;

import android.support.v4.app.Fragment;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.hackathon.cmc.R;

public class AddReviewFragment extends Fragment {
	
	public AddReviewFragment(){}
	
	@Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
            Bundle savedInstanceState) {
 
        View rootView = inflater.inflate(R.layout.fragment_add_review, container, false);
         
        return rootView;
    }
}
