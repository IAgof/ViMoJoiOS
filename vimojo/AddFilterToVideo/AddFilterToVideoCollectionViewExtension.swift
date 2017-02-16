//
//  AddFilterToVideoCollectionViewExtension.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 15/2/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import Foundation

extension AddFilterToVideoViewController:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        eventHandler?.selectedFilter(index: indexPath.item)
    }
    
    func scrollToNextElement() {
        guard let visibleItems = self.filtersCollectionView.indexPathsForSelectedItems else{return}
        let currentItem = visibleItems[0]
        
        self.filtersCollectionView.scrollToItem(at: currentItem, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
    }
}

extension AddFilterToVideoViewController:UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCollectionViewCell", for: indexPath) as! FilterCollectionViewCell
        
        cell.setUp(viewModel: filters[indexPath.item])
        
        return cell
    }
}
